"""
function which reads `L`, `T`, `bins`, `reps` and `steps`
    from the `filename` file and returns the tuple with values
"""
function read_input(filename::str)::Tuple{UInt64, Float64, UInt64, UInt64, UInt64}
    f = open(filename, "r")
    L = parse(UInt64, readline(f))
    T = parse(Float64, readline(f))
    bins = parse(UInt64, readline(f))
    reps = parse(UInt64, readline(f))
    steps = parse(UInt64, readline(f))
    close(f)
    return L, T, bins, reps, steps
end

"""
function which appends the latest average values of magnetization
    for all steps from `bins_averages` to the file named `filename`
"""
function write_bin_averages(bins_averages::Vector{Vector{Float64}}, filename::str)
    f = open(filename, "a")
    for step in 1:length(bins_averages)
        println(f, step, bins_averages[step][length(bins_averages[step])])
    end
    close(f)
end