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
        n = 100
        benchmark = @benchmarkable n rand evals=7 samples=1729
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

    @testset "End to end tests" begin
        # \/ Ensure that updates here are reflected in the Quick start tutorial in the README.md \/

        # Create a package
        import Pkg
        dir = joinpath(tempname(), "Example")
        Pkg.generate(dir; io=devnull)

        # Define benchmarks
        mkdir(joinpath(dir, "benchmark"))
        open(joinpath(dir, "benchmark", "benchmarks.jl"), "w") do io
            println(io, """
            using ChairmarksForAirspeedVelocity

            const SUITE = BenchmarkGroup()

            SUITE["main"]["random_sleep"] = @benchmarkable rand()*.1 sleep evals = 1 samples = 2
            """)
        end

        # Check in benchmarks TODO: it would be nice if AirspeedVelocity did not depend on Git.
        run(`git -C $dir init -b main`)
        run(`git -C $dir add .`)
        run(`git -C $dir -c user.name="CI" -c user.email="CI@email.org" commit -m "Initial commit"`)

        # Install AirspeedVelocity
        exe = joinpath(Base.DEPOT_PATH[1], "bin", "benchpkg")
        isfile(exe) || run(`julia -e 'using Pkg; Pkg.activate(temp=true); Pkg.add("AirspeedVelocity")'`)
        @test isfile(exe)

        # Run benchmarks
        res = cd(dir) do
            read(`$exe -add=https://github.com/LilithHafner/ChairmarksForAirspeedVelocity.jl -rev=dirty,main`, String)
        end

        table = res[only(eachmatch(r"\n\|   +\|", res)).offset:end]

        import Markdown
        @test only(Markdown.parse(table).content) isa Markdown.Table
        @test contains(table, "main")
        @test contains(table, "dirty")
        @test contains(table, "random_sleep")
        @test contains(table, "time_to_load")
        @test contains(table, "±")
        @test endswith(table, r"\d +\|\n+")

        # /\ Ensure that updates here are reflected in the Quick start tutorial in the README.md /\
    end
end
