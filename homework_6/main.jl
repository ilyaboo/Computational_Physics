include("IO_functions.jl")
include("math_functions.jl")

# setting the name for input and output files
filename_read = "read.in"
filenmae_write_magnetizations = "res.dat"

# reading input from the file
L, T, bins, reps, steps = read_input(filename_read)


# сhecking if the number of steps is not zero (first part)
if steps == zero

    # 2D vector for storing magnetizations for different runs,
    # where i-th row represents magnetizations on the n-th step
    magnetization_runs::Vector{Vector{Float64}} = [[] for _ in 1:steps]

    # running the simulation reps number of times
    for _ in 1:reps

        # initial state
        state::Vector{Vector{Int64}} = [[1 for _ in 1:L] for _ in 1:L]

        # conducting steps for Monte Carlo simulation
        for step in 1:steps

            # creating new state
            state_new::Vector{Vector{Int64}} = [[0 for _ in 1:L] for _ in 1:L]

            # applying Monte Carlo algorithm
            ...
            
            # recording new magnetization
            push!(magnetization_runs[step], get_magnetization(state_new))

            # updating current state
            state = state_new
        end
    end

    # creatring a vector of average magnetizations on each step
    average_magnetizations::Vector{Float64} = [mean(magnetization_runs[i]) for i in 1:length(magnetization_runs)]

    # recording average magnetizations

# otherwise, 0 steps (second part)
else