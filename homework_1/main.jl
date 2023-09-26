include("functions.jl")
include("graph_functions.jl")
include("IO_functions.jl")
include("math_functions.jl")

using Plots

# raading inputs
num_walks, num_steps, seed = read_input()

# recording frequencies of the resultant values of each bit
bit_counts = run_walks(num_walks, num_steps, seed)

# calculating deviations
deviations = RMS_deviations(bit_counts)

# writing the deviations into the file
write_deviations(deviations, num_walks)