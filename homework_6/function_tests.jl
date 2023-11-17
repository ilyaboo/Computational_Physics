using Test
include("math_functions.jl")

@testset "Testing get_magnetization function" begin
    @test get_magnetization([[1, 1], [-1, -1]]) == 0.0
    @test get_magnetization([[1, 1], [1, 1]]) == 1.0
    @test get_magnetization([[-1, -1], [-1, -1]]) == -1.0
    @test get_magnetization([[-1, -1], [-1, 1], [1, 1]]) == 0.0
end

@testset "Testing bins_average_and_error function" begin
    @testset "[[1.0, 2.0, 3.0], [1.0, 3.0, 5.0]]" begin
        averages, errors = bins_average_and_error([[1.0, 2.0, 3.0], [1.0, 3.0, 5.0]])
        @test averages[1] == 2.0
        @test averages[2] == 3.0
        @test errors[1] == 1.0
        @test errors[2] == 2.0
    end
    @testset "[[1.0, 4.0, 4.0], [1.0, 7.0, 16.0]]" begin
        averages, errors = bins_average_and_error([[1.0, 4.0, 4.0], [1.0, 7.0, 16.0]])
        @test averages[1] == 3.0
        @test averages[2] == 8.0
        @test errors[1] == 2.0
        @test errors[2] == 8.0
    end
end

@testset "Testing get_energy_change function" begin
    @test get_energy_change([[1, 1, 1], [1, -1, 1], [1, 1, 1]], UInt64(2), UInt64(2)) == 8.0
    @test get_energy_change([[1, 1, 1], [1, -1, 1], [1, 1, 1]], UInt64(1), UInt64(1)) == -6.0
end