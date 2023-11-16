using Test
include("math_functions.jl")

@testset "Testing get_magnetization function" begin
    @test get_magnetization([[1, 1], [-1, -1]]) == 0.0
    @test get_magnetization([[1, 1], [1, 1]]) == 1.0
    @test get_magnetization([[-1, -1], [-1, -1]]) == -1.0
    @test get_magnetization([[-1, -1], [-1, 1], [1, 1]]) == 0.0
end