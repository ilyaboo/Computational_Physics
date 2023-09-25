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