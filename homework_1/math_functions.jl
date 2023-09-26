function probability_bit_value(num_steps::UInt64, val::Int64)::Float64
    # function which calculates the expected probability
    # of eventual value that correspinded to a bit being equal to val
    # according to the formula for binomial distribution
    # Input: num_steps – number of steps in a walk
    #        val – eventual value after the walk is done
    # Output: expected probability of obtaining such a value

    # using the formula for binomial distribution
    return (Float64(1) / 2^num_steps) * factorial(big(num_steps)) / 
            (factorial(big(div(num_steps + val, 2))) * 
            factorial(big(div(num_steps - val , 2))))
end

function expected_deviation(num_walks::UInt64, num_steps::UInt64, val::Int64, actual_count::UInt64)::Float64
    # function that computes the expected deviation from the
    # actual distribution
    # Input: num_walks – number of walks performed
    #        num_steps – number of steps in each walk'
    #        val – the result value
    #        actual_count – number of such resuls obtained
    # Outupt: deviation from expected
 
    # calculating the expected number of “hits”
    C::Float64 = num_walks * probability_bit_value(num_steps, val)

    # returning the difference after normalizing
    return (C - actual_count) / num_walks
end

function total_squared_deviation_for_bit(bit_freqs::Vector{UInt64})::Float64
    # function which calculates total squared deviation for
    # a given values corresponding to the bit after the walks

    # calculating total number of walks
    num_walks::UInt64 = sum(bit_freqs)

    # calculating the total number of steps
    num_steps::UInt64 = (length(bit_freqs) - 1) / 2

    total_squared_deviation::Float64 = 0

    # iterating over values corresponding to the bit
    for i in 1:length(bit_freqs)
        value::Int64 = i - Int64(num_steps) - 1   # value at the end of the walk
        counter::UInt64 = bit_freqs[i]   # actual counter for the value

        # updating the total squared deviation
        total_squared_deviation += expected_deviation(num_walks, num_steps, value, counter)^2
    end

    return total_squared_deviation
end