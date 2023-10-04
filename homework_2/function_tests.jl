include("math_functions.jl")
using Test

@testset "Testing f(x) function" begin
    @test f(1, 1, 1) == 1/2
    @test f(0, 2, 2) == 1/4
    @test f(0, 0, 1) == Inf
    @test f(-1, 0, 0) == 1
end

@testset "Testing discretization_step function" begin
    @test discretization_step(5.0, UInt64(10)) == 0.5
    @test discretization_step(0.0, UInt64(10)) == 0
    @test discretization_step(3213.0, UInt64(31432423)) ≈ 0.00010221929
    @test discretization_step(31432423.0, UInt64(3213)) ≈ 9782.88920012
end

@testset "Testing first_order_integration function" begin
    @test round(first_order_integration(1000000.0, UInt64(1000000000), 1.0, 1.0), digits = 3) ≈ 13.816
    @test round(first_order_integration(1000000.0, UInt64(1000000000), 1.0, 2.0), digits = 3) ≈ 1.000
end

@testset "Testing second_order_integration function" begin
    @test round(second_order_integration(1000000.0, UInt64(1000000000), 1.0, 1.0), digits = 3) ≈ 13.816
    @test round(second_order_integration(1000000.0, UInt64(1000000000), 1.0, 2.0), digits = 3) ≈ 1.000
end

@testset "Testing is_inside_sphere function" begin
    @test is_inside_sphere(1.0, 1.0, 0.0, 2.0) == true
    @test is_inside_sphere(1.0, 2.0, 3.0, 2.0) == false
end

@testset "Testing is_inside_cylinder function" begin
    @test is_inside_cylinder(1.0, 1.0, 1.0) == false
    @test is_inside_cylinder(0.0, 1.0, 1.0) == true
end

@testset "Testing added_inertia function" begin
    @test added_inertia(0.5, 0.5, 0.0, 1.0, 5.0, 10.0) == (10.0 * 0.5^2, 10.0 * (0.5^2 + 0.5^2))
    @test added_inertia(2.0, 0.5, 0.0, 1.0, 5.0, 10.0) == (5.0 * 0.5^2, 5.0 * (2.0^2 + 0.5^2))
end