include("math_functions.jl")
include("constants.jl")
using Test

@testset "Testing get_accelerations function" begin
    @test get_accelerations((42164000.0, 0.0, 0.0), (2 * 42164000.0, 0.0, 0.0))[1] ≈ -G * Me / 42164000.0^2 + G * Mm / 42164000.0^2
    @test get_accelerations((42164000.0, 0.0, 0.0), (2 * 42164000.0, 0.0, 0.0))[2] == 0
    @test get_accelerations((0.0, 42164000.0, 0.0), (0.0, 2 * 42164000.0, 0.0))[1] == 0
    @test get_accelerations((0.0, 42164000.0, 0.0), (0.0, 2 * 42164000.0, 0.0))[2] ≈ -G * Me / 42164000.0^2 + G * Mm / 42164000.0^2
end