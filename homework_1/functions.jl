# parameters of the random number generator
a::UInt64 = 2862933555777941757
c::UInt64 = 1013904243


function generate_random(r::UInt64)::UInt64
    # function that implements a linear congruential
    # generator
    # Input: r – last generated number
    # Optupt: r_new – new generated number

    # calculating the new number
    r_new::UInt64 = a * r + c
    return r_new

end