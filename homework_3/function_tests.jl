include("math_functions.jl")
include("constants.jl")
using Test


@testset "Testing get_accelerations function" begin
    @test get_accelerations((Rs, 0.0, 0.0), (Rm, 0.0, 0.0))[1] ≈ -GMe / Rs^2 + GMm / (Rm - Rs)^2
    @test get_accelerations((Rs, 0.0, 0.0), (Rm, 0.0, 0.0))[2] ≈ 0.0
    @test get_accelerations((Rs, 0.0, 0.0), (Rm, 0.0, 0.0))[3] ≈ 0.0
    @test get_accelerations((0.0, Rs, 0.0), (0.0, Rm, 0.0))[1] ≈ 0.0
    @test get_accelerations((0.0, Rs, 0.0), (0.0, Rm, 0.0))[2] ≈ -GMe / Rs^2 + GMm / (Rm - Rs)^2
    @test get_accelerations((0.0, Rs, 0.0), (0.0, Rm, 0.0))[3] ≈ 0.0
    @test get_accelerations((0.0, Rs, 0.0), (0.0, -Rm, 0.0))[1] ≈ 0.0
    @test get_accelerations((0.0, Rs, 0.0), (0.0, -Rm, 0.0))[2] ≈ -GMe / Rs^2 - GMm / (Rm + Rs)^2
    @test get_accelerations((0.0, Rs, 0.0), (0.0, -Rm, 0.0))[3] ≈ 0.0
end

@testset "Testing get_moon_pos function" begin
    @test get_moon_pos(0.0, 0.0) == (Rm, 0.0, 0.0)
    @test get_moon_pos(Tm, 0.0)[1] == Rm
    @test abs(get_moon_pos(Tm, 0.0)[2]) < 10^-7
    @test abs(get_moon_pos(Tm, 0.0)[3]) < 10^-7
end