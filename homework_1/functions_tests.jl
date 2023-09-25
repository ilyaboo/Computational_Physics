include("functions.jl")

using Test

# testing the record_walk_results function
@test begin
    walk = [[0, 1], [0, -1]]
    bit_counts = [[0, 0, 0], [0, 0, 0]]
    record_walk_results(bit_counts, walk)
    bit_counts == [[0, 0, 1], [1, 0, 0]]
end