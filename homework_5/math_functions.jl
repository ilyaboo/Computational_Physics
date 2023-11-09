using LinearAlgebra
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
        return V0 / π^2 * 
                (((sin(π * (x0 + a) * (Float64(p_x) - Float64(k_x)) / Lx) / (Float64(p_x) - Float64(k_x))) -
                (sin(π * (x0 + a) * (Float64(p_x) + Float64(k_x)) / Lx) / (Float64(p_x) + Float64(k_x)))) - 
                ((sin(π * x0 * (Float64(p_x) - Float64(k_x)) / Lx) / (Float64(p_x) - Float64(k_x))) -
                (sin(π * x0 * (Float64(p_x) + Float64(k_x)) / Lx) / (Float64(p_x) + Float64(k_x))))) *

                (((sin(π * (Ly - y0) * (Float64(p_y) - Float64(k_y)) / Ly) / (Float64(p_y) - Float64(k_y))) -
                (sin(π * (Ly - y0) * (Float64(p_y) + Float64(k_y)) / Ly) / (Float64(p_y) + Float64(k_y)))) - 
                ((sin(π * (Ly - y0 - b) * (Float64(p_y) - Float64(k_y)) / Ly) / (Float64(p_y) - Float64(k_y))) -
                (sin(π * (Ly - y0 - b) * (Float64(p_y) + Float64(k_y)) / Ly) / (Float64(p_y) + Float64(k_y)))) +
                ((sin(π * (y0 + b) * (Float64(p_y) - Float64(k_y)) / Ly) / (Float64(p_y) - Float64(k_y))) -
                (sin(π * (y0 + b) * (Float64(p_y) + Float64(k_y)) / Ly) / (Float64(p_y) + Float64(k_y)))) - 
                ((sin(π * y0 * (Float64(p_y) - Float64(k_y)) / Ly) / (Float64(p_y) - Float64(k_y))) -
                (sin(π * y0 * (Float64(p_y) + Float64(k_y)) / Ly) / (Float64(p_y) + Float64(k_y)))))
    else
        return 0.0
    end
end


"""
function whcih constructs the Hamiltonian matrix
"""
function construct_hamiltonian(Nx::UInt64, Ny::UInt64)::Array{Float64,2}

    # the total number of states is Nx * Ny
    N = Nx * Ny

    # initializing the Hamiltonian matrix with zeros
    H = zeros(Float64, N, N)  

    # iterating over all states
    for kx in 1:Nx
        for ky in 1:Ny

            # calculating state index
            k_index = get_state_index(kx, ky, Nx)
            
            # calculating kinetic energy term
            H[k_index, k_index] = get_beta_times_kinetic_energy(kx, ky)
            
            # calculating potential energy terms
            for px in 1:Nx
                for py in 1:Ny

                    # calculating index for the state (px, py)
                    p_index = get_state_index(px, py, Nx)
                    
                    # calculating the potential energy contribution
                    potential_energy_contribution = get_potential_energy(kx, px, ky, py, x, y)
                    
                    # plugging in potential energy to the Hamiltonian
                    H[k_index, p_index] += potential_energy_contribution

                    # checkign for symmetry
                    if k_index != p_index
                        H[p_index, k_index] = H[k_index, p_index]
                    end
                end
            end
        end
    end
    
    return H
end

# constructing the Hamiltonian
# Hamiltonian = construct_hamiltonian(Nx, Ny)
# eigenvalues, eigenvectors = eigen(Hamiltonian)

"""
function which returns the wave function
    given the `eigenvector`, `N_x`, `N_y`, `x_grid` and `y_grid`
"""
function construct_wave_function(eigenvector::Array{Float64,1}, N_x::UInt64, N_y::UInt64, x_grid::UInt64, y_grid::UInt64)::Array{Float64,2}

    # initializing the wave function 2D array
    wave_function = zeros(Float64, x_grid, y_grid)
    
    # defining the grid spacing
    dx = Lx / (x_grid - 1)
    dy = Ly / (y_grid - 1)
    
    # iterating over each grid point to calculate the wave function value
    for i in 1:x_grid

        # current x coordinate
        x = (i - 1) * dx 

        for j in 1:y_grid

            # current y coordinate
            y = (j - 1) * dy 

            # initializing the value for this grid point
            wave_function_value = 0.0
            
            # iterating over all combinations of basis functions
            for kx in 1:N_x
                for ky in 1:N_y

                    # calculating the single index for this combination
                    k_index = get_state_index(kx, ky, N_x)
                    
                    # adding the contribution from this basis function
                    wave_function_value += eigenvector[k_index] * f_k_x(x, kx) * g_k_y(y, ky)
                end
            end
            
            # assigning the calculated value to the wave function at this grid point
            wave_function[i, j] = wave_function_value
        end
    end

    return wave_function
end