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

function compute_wave_function(r_max::Float64, delta_r::Float64, a::Float64, V0::Float64)::Vector{Float64}
    # function which returns values of the wave function

    # initial values
    U_prev::Float64 = 0.0001
    U::Float64 = 0.0002
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

function find_bound_state(a::Float64, delta_V::Float64, r_max::Float64, delta_r::Float64)::Float64
    # function which calculates the value of the
    # potnetial of the bound state

    # current V0 / E that is being checked
    V0_over_E = 0.0

    # current value of the wave function
    U = 0.0

    while true

        # calculating new value of the wave function
        U_new = last(compute_wave_function(r_max, delta_r, a, -(V0_over_E + delta_V) * abs(E)))
        println(U, U_new)
        # checking if the values changed sign compared to the previous one
        if U * U_new < 0.0
            break
        else
            # updating potential and wave function value
            V0_over_E += delta_V
            U = U_new
        end
    end

    # using bisection to find V0/E for which boundary
    # condition is satisfied
    V0_over_E_left = V0_over_E
    V0_over_E_right = V0_over_E + delta_V
    U_left = compute_wave_function(r_max, delta_r, a, (V0_over_E_left) * abs(E))
    U_right = compute_wave_function(r_max, delta_r, a, (V0_over_E_right) * abs(E))
    V0_over_E_mid::Float64 = 0.0
    for _ in 1:10000

        # calculating the value in the middle
        V0_over_E_mid = (V0_over_E_left + V0_over_E_right) / 2

        # calculating the wave function value in the middle
        U_mid = compute_wave_function(r_max, delta_r, a, (V0_over_E_mid) * abs(E))

        # checking if should move to the left side 
        if last(U_left) * last(U_mid) < 0.0
            V0_over_E_right = V0_over_E_mid
        else
            V0_over_E_left = V0_over_E_mid
        end
    end

    return V0_over_E_mid * abs(E)
end

function compute_radius(V0::Float64, delta_r::Float64, r_max::Float64, a::Float64)::Float64
    # function that uses calculated VO for the bound state
    
    # obtain the wave function for V0_val
    U_vals = compute_wave_function(r_max, delta_r, a, V0)

    # storing the expected squared radius
    expected_r2::Float64 = 0.0

    # iterating over values of the wave function
    # in order to intedrate
    for i in 1:length(U_vals)

        # calculating the distance
        r = delta_r * i

        # adding the contribution to the total
        expected_r2 += 4 * π * r * U_vals[i]^2 * delta_r
    end

    # returning the radius
    return sqrt(expected_r2)
end