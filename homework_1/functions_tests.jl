include("functions.jl")
include("math_functions.jl")

using Test

# testing the record_walk_results function
@test begin
    walk = [[0, 1], [0, -1]]
    bit_counts = [UInt64[0, 0, 0], UInt64[0, 0, 0]]
    record_walk_results(bit_counts, walk)
    bit_counts == [[0, 0, 1], [1, 0, 0]]
end

# testing the probability_bit_value function
@test probability_bit_value(UInt64(1), 1) == Float64(0.5)
@test probability_bit_value(UInt64(1), -1) == Float64(0.5)
@test probability_bit_value(UInt64(2), 0) == Float64(0.5)
@test probability_bit_value(UInt64(2), -2) == Float64(0.25)
@test probability_bit_value(UInt64(25), 25) == Float64(1) / 2^25
@test probability_bit_value(UInt64(100), -100) == Float64(1) / 2^100

# testing the expected_deviation function
@test expected_deviation(UInt64(2), UInt64(1), 1, UInt64(1)) == Float64(0)
@test expected_deviation(UInt64(2), UInt64(1), 1, UInt64(0)) == Float64(0.5)
@test expected_deviation(UInt64(2), UInt64(1), -1, UInt64(0)) == Float64(0.5)
@test expected_deviation(UInt64(10), UInt64(1), 1, UInt64(4)) == Float64(0.1)