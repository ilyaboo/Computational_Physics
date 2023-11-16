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