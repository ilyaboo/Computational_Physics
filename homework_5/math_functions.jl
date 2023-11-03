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

"""
function that returns the kinetic enery term
    of the hamiltonian multiplied by `β`, given `k_x` and `k_y`
"""
function get_beta_times_kinetic_energy(k_x::UInt64, k_y::UInt64)::Float64
    return π^2 / 2 * ((Float64(k_x) / L_x)^2 + (Float64(k_y) / L_y)^2)
end

"""
function which checks if the given pair of coordinates `(x, y)` corresponds
    to one of the two rectangular regions that have a potential of V0
"""
function check_if_inside_rectangles(x::Float64, y::Float64)::Bool
    
    # horizontal check 
    if x >= x0 && x <= Lx - x0
        
        # vertical check for bottom rectangle 
        if y >= y0 && y <= y0 + b
            return true
        
        # vertical check for top rectangle
        elseif y >= Ly - y0 - b && y <= Ly - y0
            return true
        end
    end
    return false
end

"""
function that returns the potnetial energy term of the 
    variational Hamiltonian using `k_x`, `p_x`, `k_y`, `p_y`, `x`, `y`
"""
function get_potential_energy(k_x::UInt64, p_x::UInt64, k_y::UInt64, p_y::UInt64, x::Float64, y::Float64)::Float64
    if check_if_inside_rectangles(x, y)
        return V0 / π^2 * ((sin(π * x * (Float64(p_x) - Float64(k_x)) / Lx) / (Float64(p_x) - Float64(k_x))) -
                (sin(π * x * (Float64(p_x) + Float64(k_x)) / Lx) / (Float64(p_x) + Float64(k_x)))) *
                ((sin(π * y * (Float64(p_y) - Float64(k_y)) / Ly) / (Float64(p_y) - Float64(k_y))) -
                (sin(π * y * (Float64(p_y) + Float64(k_y)) / Ly) / (Float64(p_y) + Float64(k_y))))
    else
        return 0.0
    end
end