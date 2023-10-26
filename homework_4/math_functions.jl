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

function compute_wave_function(r_max::Float64, delta_r::Float64, a::Float64, V0::Float64)::Float64
    # function which returns values of the wave function

    # initial values
    U_prev::Float64 = 0.01
    U::Float64 = 0.02
    r::Float64 = r_max

    # storing the U values
    U_values = Float64[]

    # iterating until reach the boundary
    while r > r0

        # calculating current potential
        V = get_potential(r, a, V0)

        # calculating the derivative
        dU_dr = beta * (V - E) * U + U_prev - U

        # updating U values
        U_prev = U
        U += delta_r * dU_dr

        # updating r
        r -= delta_r

        # stroing the calculated value
        push!(U_values, U)
    end
    
    return U_values
end
