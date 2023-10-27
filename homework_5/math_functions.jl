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



