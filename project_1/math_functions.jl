using SpecialFunctions

function probability_bit_value_slow(num_steps::UInt64, val::Int64)::Float64
    # function which calculates the expected probability
    # of eventual value that correspinded to a bit being equal to val
    # according to the formula for binomial distribution
    # Input: num_steps – number of steps in a walk
    #        val – eventual value after the walk is done
    # Output: expected probability of obtaining such a value

    # if num_steps and val are different in parity, val
    # cannot be obtained and probability is zero
    if num_steps % 2 != abs(val % 2)
        return Float64(0)
    end

    # using the formula for binomial distribution
    return (Float64(1) / 2^num_steps) * factorial(big(num_steps)) / 
            (factorial(big(div(num_steps + val, 2))) * 
            factorial(big(div(num_steps - val , 2))))
end

function probability_bit_value(num_steps::UInt64, val::Int64)::Float64
    # function which calculates the expected probability
    # of eventual value that correspinded to a bit being equal to val
    # according to the formula for binomial distribution
    # uses the logarithmic approach to avoid errors in calculations
    # Input: num_steps – number of steps in a walk
    #        val – eventual value after the walk is done
    # Output: expected probability of obtaining such a value

    # if num_steps and val are different in parity, val
    # cannot be obtained and probability is zero
    if num_steps % 2 != abs(val % 2)
        return Float64(0)
    end
    
    # converting to floats
    num_steps = Float64(num_steps)
    val = Float64(val)

    # calculating the logarithm of the probability
    log_value = -num_steps * log(2.0) + loggamma(num_steps + 1) - 
    loggamma((num_steps + val) / 2 + 1) - loggamma((num_steps - val) / 2 + 1)
    
    # converting back from the logarithmic value
    return exp(log_value)
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
    # Input: bit_freqs – records of the bit after all walks
    # Output: total squared deviation

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

function RMS_deviation_for_bit(bit_freqs::Vector{UInt64})::Float64
    # function which calculates root-mean-square deviation for
    # a given values corresponding to the bit after the walks
    # Input: bit_freqs – records of the bit after all walks
    # Output: RMS deviation

    return total_squared_deviation_for_bit(bit_freqs) ^ 0.5
end

function RMS_deviations(bit_counts::Vector{Vector{UInt64}})::Vector{Float64}
    # functiuon that calculates the RMS deviations for all bits
    # Input: bit_counts – 2D array with results after all walks are conducted
    # Output: array with RMS deviations for all bits

    deviations = zeros(Float64, 64)

    # iterating over bits
    for i in 1:64

        # recording results
        deviations[i] = RMS_deviation_for_bit(bit_counts[i])
    end

    return deviations
end