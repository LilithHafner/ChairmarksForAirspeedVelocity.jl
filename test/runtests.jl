using ChairmarksForAirspeedVelocity
using Test
using Aqua

@testset "ChairmarksForAirspeedVelocity.jl" begin
    @testset "Aqua" begin
        import Aqua
        # persistent_tasks=false because that test is slow and we don't use persistent tasks
        Aqua.test_all(Chairmarks, deps_compat=false, persistent_tasks=false)
        Aqua.test_deps_compat(Chairmarks, check_extras=false)
    end

    @testset "@benchmarkable" begin
        benchmark = @benchmarkable 100 rand evals=7 samples=1729
        @test ChairmarksForAirspeedVelocity.BenchmarkTools.tune!(benchmark) === nothing
        result = run(benchmark)
        @test result.params.evals == 7
        @test result.params.samples == 1729
        @test result.times isa Vector{Float64}
        @test result.gctimes isa Vector{Float64}
        @test 10 < minimum(result.times) < 100_000 # measured in nanoseconds
        @test maximum(result.gctimes) < 100_000_000 # measured in nanoseconds (could be zero)
        @test result.memory isa Int
        @test result.allocs isa Int
        @test result isa ChairmarksForAirspeedVelocity.BenchmarkTools.Trial
    end

    @testset "BenchmarkGroup" begin
        BenchmarkGroup()
    end
end
