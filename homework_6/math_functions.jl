using Statistics
using Random

"""
function which calculates magnetization `m` of the state
"""
function get_magnetization(state::Vector{Vector{Int64}})::Float64
    total::Float64 = 0.0
    for i in 1:length(state)
        for j in 1:length(state[1])
            total += state[i][j]
        end
    end
    return total / (length(state) * length(state[1]))
end

"""
function that calculate the average magnetizations and errors
    for a given values of a bin
"""
function bins_average_and_error(magnetization_runs_bins::Vector{Vector{Float64}})::Tuple{Vector{Float64}, Vector{Float64}}
    averages::Vector{Float64} = []
    errors::Vector{Float64} = []
    for step in 1:length(magnetization_runs_bins)
        average_value = mean(magnetization_runs_bins[step])
        push!(averages, average_value)

        # calculating error as maximum absolute deviation from average
        push!(errors, max((maximum(magnetization_runs_bins[step]) - average_value), (average_value - minimum(magnetization_runs_bins[step]))))
    end
    
    return averages, errors
end

"""
function which returns the change in energy caused by the flip
    of the spin of the considered particle, using current state
    `state`, as well as coordinates of the particle `x` and `y`
"""
function get_energy_change(state::Vector{Vector{Int64}}, x::UInt64, y::UInt64)::Float64

    # storing the total energy change
    total_energy_change::Int64 = 0

    # vectors for x and y values of the neighbors
    x_vals_neigh::Vector{UInt64} = [x - 1, x, x + 1]
    y_vals_neigh::Vector{UInt64} = [y - 1, y, y + 1]

    # wrapping around coordinates if necessary
    if x_vals_neigh[1] == 0
        x_vals_neigh[1] = length(state)
    end
    if y_vals_neigh[1] == 0
        y_vals_neigh[1] = length(state[1])
    end
    if x_vals_neigh[3] == length(state) + 1
        x_vals_neigh[3] = 1
    end
    if y_vals_neigh[3] == length(state[1]) + 1
        y_vals_neigh[3] = 1
    end

    # considering all neighbors
    for x_val in x_vals_neigh
        for y_val in y_vals_neigh

            # checking that it is not the coordinated of the original particle
            if !(x_val == x && y_val == y)
                
                # updating total_energy
                total_energy_change += state[x][y] * state[x_val][y_val]
            end
        end
    end

    return -Float64(total_energy_change)
end

"""
function which returns a boolean result on whether
    the spin should be flipped or not using the current
    `state` and coordinates `x` and `y` of the particle considered
"""
function should_flip(state::Vector{Vector{Int64}}, x::UInt64, y::UInt64)::Bool

    # calculating energy change
    delta_energy = get_energy_change(state, x, y)

    # if energy change is negative (energy decreased), accept the change
    if delta_energy <= 0
        return true
    
    # otherwise, consider probability
    else
        return rand() < exp(-delta_energy / T)
    end
end

"""
function which conducts Monte Carlo algorithm with 
    a given 2D array `state` and uses initial total
    magnetization `M` to calculate the its new value,
    which is then returned
"""
function conduct_Monte_Carlo(state::Vecotor{Vector{Int64}}, M::Int64)::Int64

    # applying Monte Carlo algorithm, by conducting N = L^2 flip attempts
    for _ in 1:lenght(state) * length(state[1])

        # picking a random particle
        x_rand, y_rand = rand(1:lenght(state)), rand(1:length(state[1]))

        # checking if it will be flipped
        if should_flip(state, x_rand, y_rand)

            # updating the total magnetization
            M -= 2 * state[x_rand][y_rand]

            # updating the spin in the state
            state[x_rand][y_rand] *= -1
        end
    end

    return M
end