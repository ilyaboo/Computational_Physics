include("constants.jl")

"""
returns the value of the basis function `f_k_x`
    for the given x-coordinate `x` and wave number `k_x`
"""
function f_k_x(x::Float64, k_x::UInt64)::Float64
    return sqrt(2 / Lx) * sin(k_x * π * x / Lx)
end

"""
returns the value of the basis function `g_k_y`
    for the given y-coordinate `y` and wave number `k_y`
"""
function g_k_y(y::Float64, k_y::UInt64)::Float64
    return sqrt(2 / Ly) * sin(k_y * π * y / Ly)
end

"""
function that returns the index of the state given
    `k_x`, `k_y` and `N_x`
"""
function get_state_index(k_x::UInt64, k_y::UInt64, N_x::UInt64)::UInt64
    return k_x + (k_y - 1) * N_x
end