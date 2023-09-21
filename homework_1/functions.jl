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

function extract_bits(r::UInt64)::Array{Int64, 1}
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

function update_walks(walks::Array{Array{Int64, 1}, 1}, b::Array{Int64, 1})
    # function that updates the walks provided by the walks array
    # by adding the next values according to the steps arrat b
    # Input: walks – array with current paths
    #        b – array with steps needed to take
    for i in 1:length(walks)
        b[i] = b[i] * 2 - 1
        append!(walks[i], walks[i][end] + b[i])
    end
end


