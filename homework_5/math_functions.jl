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
    return π^2 / 2 * ((Float64(k_x) / Lx)^2 + (Float64(k_y) / Ly)^2)
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
function which returns the potential given the
    coordinates `x` and `y`
"""
function V(x::Float64, y::Float64)::Float64
    if check_if_inside_rectangles(x, y)
        return V0
    else
        return 0.0
    end 
end

"""
function that returns the potnetial energy term of the 
    variational Hamiltonian using `k_x`, `p_x`, `k_y`, `p_y`, `x`, `y`
"""

function get_potential_energy(k_x::UInt64, p_x::UInt64, k_y::UInt64, p_y::UInt64)::Float64

    # helper function to safely calculate the sinc function avoiding division by zero
    function safe_sinc(dividend, divisor)
        if divisor == 0
            return 1.0   # sinc(0) = 1
        else
            return sin(dividend * divisor) / divisor
        end
    end
    
    # calculating each term using the safe_sinc function
    term1_x = safe_sinc(π * (x0 + a) / Lx, Float64(p_x) - Float64(k_x))
    term2_x = safe_sinc(π * (x0 + a) / Lx, Float64(p_x) + Float64(k_x))
    term3_x = safe_sinc(π * x0 / Lx, Float64(p_x) - Float64(k_x))
    term4_x = safe_sinc(π * x0 / Lx, Float64(p_x) + Float64(k_x))

    term1_y = safe_sinc(π * (Ly - y0) / Ly, Float64(p_y) - Float64(k_y))
    term2_y = safe_sinc(π * (Ly - y0) / Ly, Float64(p_y) + Float64(k_y))
    term3_y = safe_sinc(π * (Ly - y0 - b) / Ly, Float64(p_y) - Float64(k_y))
    term4_y = safe_sinc(π * (Ly - y0 - b) / Ly, Float64(p_y) + Float64(k_y))
    term5_y = safe_sinc(π * (y0 + b) / Ly, Float64(p_y) - Float64(k_y))
    term6_y = safe_sinc(π * (y0 + b) / Ly, Float64(p_y) + Float64(k_y))
    term7_y = safe_sinc(π * y0 / Ly, Float64(p_y) - Float64(k_y))
    term8_y = safe_sinc(π * y0 / Ly, Float64(p_y) + Float64(k_y))

    # combining the terms for the final potential energy contribution
    potential_energy = V0 / π^2 * ((term1_x - term2_x) - (term3_x - term4_x)) * 
                                 ((term1_y - term2_y) - (term3_y - term4_y) + 
                                  (term5_y - term6_y) - (term7_y - term8_y))
    return potential_energy
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
                    potential_energy_contribution = get_potential_energy(kx, px, ky, py)
                    
                    # plugging in potential energy to the Hamiltonian
                    H[k_index, p_index] += potential_energy_contribution
                    
                    # checking for symmetry
                    if k_index != p_index
                        H[p_index, k_index] = H[k_index, p_index]
                    end
                end
            end
        end
    end
    
    return H
end

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

"""
function that executes the Lanczos algorithm based on
    `H`, which is the function which returns the Hamiltonian value, `initial_state`,
    which is the initial state, `num_steps` for the number of iterations of lanczos_iteration
    and returns a tuple `(eigenvalues, eigenvectors)`
"""
function lanczos_iteration(H::Function, initial_state::Vector{Float64}, num_steps::UInt64) :: Tuple{Vector{Float64}, Matrix{Float64}}

    # creating a matrix to store the Krylov subspace vectors
    Q = Matrix{Float64}(undef, length(initial_state), num_steps)

    # storing diagonal and off-diagonal elements
    alpha = Vector{Float64}(undef, num_steps)
    beta = Vector{Float64}(undef, num_steps - 1)

    # normalizing the initial state and moving it
    # to the first column of Q
    q = initial_state / norm(initial_state)
    Q[:, 1] = q

    # applying the hamiltonian for the initial state
    r = H(q)

    # computing the first diagonal element of the tridiagonal matrix
    alpha[1] = dot(q, r)

    # updating the residual vector by subtracting the component along q
    r -= alpha[1] * q

    # computing the first off-diagonal element
    beta[1] = norm(r)

    # updating q to be the next basis vector of the Krylov subspace
    q = r / beta[1]

    # iteraing over steps of Lanczos algorithm
    for j = 2:num_steps

        # recording the current state
        Q[:, j] = q

        # recording diagonal element
        r = H(q) - beta[j - 1] * Q[:, j - 1]
        alpha[j] = dot(q, r)

        # checking if the last step
        # if not, recording off-diagonal element and updating the state
        if j < num_steps
            r -= alpha[j] * q
            beta[j] = norm(r)
            q = r / beta[j]
        end
    end

    # constructing the tridiagonal matrix
    T = SymTridiagonal(alpha, beta)

    # obtaining eigenvalues and eigenvectors of the tridiagonal matrix
    eigenvalues, eigenvectors_T = eigen(T)

    # transforming back the eigenvectors to the original space
    eigenvectors = Q * eigenvectors_T

    return eigenvalues, eigenvectors
end