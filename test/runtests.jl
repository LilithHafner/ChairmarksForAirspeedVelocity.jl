using ChairmarksForAirspeedVelocity
using Test
using Aqua

@testset "ChairmarksForAirspeedVelocity.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ChairmarksForAirspeedVelocity)
    end
    # Write your tests here.
end
