include("math_functions.jl")
using Test

@testset "Testing f(x) function" begin
    @test f(1, 1, 1) == 1/2
    @test f(0, 2, 2) == 1/4
    @test f(0, 0, 1) == Inf
    @test f(-1, 0, 0) == 1
end