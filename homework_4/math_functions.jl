include("constants.jl")

function get_potential(r::Float64, a::Float64, V0::Float64)::Float64
    # function that returns full potential based on
    # the distance, range parameter and depth parameter

    # if distance is less that hard-core barrier, return infinity
    if r < r0
        return Inf
    else
        return -V0 * ℯ^(-r / a) * a / r
    end
end