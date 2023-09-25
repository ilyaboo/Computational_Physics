# parameters of the random number generator
const a::UInt64 = 2862933555777941757
const c::UInt64 = 1013904243


function generate_random(r::UInt64)::UInt64
    # function that implements a linear congruential
    # generator
    # Input: r – last generated number
    # Optupt: new generated number

    # calculating the new number and returning it
    return a * r + c
end

function extract_bits(r::UInt64)::Vector{Int64}
    # function that takes a generated number r
    # and extracts its 64 bits into the Array
    # Input: r – UInt64 number to extract bits from
    # Optupt: b – array of length 64 that stores
    # bits of r as separate elements

    b = Array{Int64, 1}(undef, 64) # initializing the array

    # iterating over bits
    for i in 1:64
        # recording the bits
        b[i] = (r >>> (i - 1)) & 1
    end
    return b
end

function update_walks_with_b(walks::Vector{Vector{Vector}}, b::Vector{Int64})
    # function that updates the walks provided by the walks array
    # by adding the next values according to the steps arrat b
    # Input: walks – array with current paths
    #        b – array with steps needed to take
    for i in 1:length(walks)
        b[i] = b[i] * 2 - 1
        append!(walks[i], walks[i][end] + b[i])
    end
end

function update_walks_with_seed(walks::Vector{Vector{Int64}}, seed::UInt64)
    # function that utilizes extract_bits and update_walks_with_b to
    # update walks array according to the randomly generated number

    # extractring random bits
    b = extract_bits(seed)

    # updating walks
    update_walks_with_b(walks, b)
end

function perform_walk(steps::UInt64, seed::UInt64)::Tuple{Vector{Vector{Int64}}, UInt64}
    # function that takes the number of steps as an argument
    # and the seed and performs the walk for a given number of steps
    # also returns that final seed value that was used
    # Input: steps – number of steps in the walk
    #        seed – initial seed of the walks
    # Output: Array containing all 64 bits changes of a walk

    # array storing walks
    walk = [Int64[0] for _ in 1:64]

    for _ in 1:steps
        seed = generate_random(seed)
        update_walks_with_seed(walk, seed)
    end

    return walk, seed
end

function record_walk_results(bit_counts::Vector{Vector{Int64}}, walk::Vector{Vector{Int64}})
    # function which record the result of the walk into the
    # bit counts matrix
    # Input: bit_counts – martix that stores the counts of bits
    #        walk – walk data that is used to update bit_counts

    # iterating over bits of the walk
    for i in 1:length(walk)

        # incrementing the corresponding counter
        bit_counts[i][walk[i][end] + length(walk)] += 1

    end
end

function run_walks(num_walks::UInt64, num_steps::UInt64, seed::UInt64)::Vector{Vector{Int64}}
    # main function which runs all the walks and teturns resultant bit counts
    # Input: num_walks – number of walks to be performed
    #        num_steps – number of steps in each walk
    #        seed – seed that is used for random
    # Output: bit_counts – 2D array that stores the frequencies of the results
    #                      of the bit values

    # creating a bit_counts 2D array with the number of columns equal to 
    # 64 corresponding to 64 bits and 2 * num_steps + 1 rows representing
    # all possible final bit values
    bit_counts = [zeros(UInt64, 64) for _ in 1:(2 * num_steps + 1)]

    # iterating num_walks times
    for _ in 1:num_walks

        # performing the walk, recording the results
        walk, seed = perform_walk(num_steps, seed)
        record_walk_results(bit_counts, walk)
    
    end

    return bit_counts
end