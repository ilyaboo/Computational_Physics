using Statistics

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
function bins_average_and_error(magnetization_runs_bin::Vector{Vector{Float64}})::Tuple{Vector{Float64}, Vector{Float64}}
    averages::Vector{Float64} = []
    errors::Vector{Float64} = []
    for step in 1:length(magnetization_runs_bin)
        average_value = mean(magnetization_runs_bin[step])
        push!(averages, average_value)

        # calculating error as maximum absolute deviation from average
        push!(errors, max((maximum(magnetization_runs_bin[step]) - average_value), (average_value - minimum(magnetization_runs_bin[step]))))
    end
    
    return averages, errors
end