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

    # number of spatial points
    nx = Int64(round((r_max - r0) / delta_r)) + 1

    # initializing wave function values and phi values
    U = zeros(Float64, nx)
    phi = zeros(Float64, nx)

    # setting initial conditions
    U[end] = 0.0000001
    U[end - 1] = 0.000002
    phi[end] = U[end]
    phi[end - 1] = U[end - 1]

    # dx^2 value
    dx2 = delta_r^2

    # fn1 value
    fn1 = 2 * (get_potential(r_max - delta_r, a, V0) - E)

    # iterating over spatial points
    # using Numerov's method to update velues
    for n = (nx-3):-1:1
        phi[n] = dx2 * fn1 * U[n + 1] + 2 * phi[n + 1] - phi[n + 2]
        fn1 = 2 * (get_potential(r0 + n * delta_r, a, V0) - E)
        U[n] = phi[n + 1] / (1 - dx2 * fn1)
    end

    return U
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
        U_new = compute_wave_function(r_max, delta_r, a, (V0_over_E + delta_V) * abs(E))[1]
        #println(U_new)

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
    U_left = compute_wave_function(r_max, delta_r, a, (V0_over_E_left) * abs(E))[1]
    V0_over_E_mid::Float64 = 0.0
    for _ in 1:100

        # calculating the value in the middle
        V0_over_E_mid = (V0_over_E_left + V0_over_E_right) / 2

        # calculating the wave function value in the middle
        U_mid = compute_wave_function(r_max, delta_r, a, (V0_over_E_mid) * abs(E))[1]

        # checking if should move to the left side 
        if U_left * U_mid < 0.0
            V0_over_E_right = V0_over_E_mid
        else
            V0_over_E_left = V0_over_E_mid
            U_left = U_mid
        end
    end

    return V0_over_E_mid * abs(E)
end


function normalize_wave_function(U::Vector{Float64}, delta_r::Float64)::Vector{Float64}
    # function that normalizes the probability function

    # storing the integral value
    integral = 0.0

    # calculating the integral
    for i in 1:length(U)
        r = r0 + (i-1) * delta_r
        integral += (U[i]^2) * (r^2) * delta_r
    end

    # taking the square root for normalization constant
    norm_const = sqrt(integral)

    return U ./ norm_const
end

function compute_radius(V0::Float64, delta_r::Float64, r_max::Float64, a::Float64)::Float64
    # function that uses calculated VO for the bound state

    # obtaining the function
    U = normalize_wave_function(compute_wave_function(r_max, delta_r, a, V0), delta_r)
    
    # storing the integral value
    integral = 0.0
    
    # calculating the integral
    for i in 1:length(U)
        r = r0 + (i - 1) * delta_r
        integral += (U[i]^2) * (r^4) * delta_r
    end

    return sqrt(4 * π * integral)
end