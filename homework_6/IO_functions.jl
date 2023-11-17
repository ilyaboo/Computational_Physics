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
function which writes the average values of magnetization
    on each step `t` for a bin to the file named `filename`
"""
function write_magnitizations_bin(filename::str)