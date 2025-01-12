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
end
