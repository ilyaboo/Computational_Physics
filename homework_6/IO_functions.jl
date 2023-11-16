"""
function which reads `L`, `T`, `bins`, `reps` and `steps`
    from the `read.in` file and returns the tuple with values
"""
function read_input()::Tuple{UInt64, Float64, UInt64, UInt64, UInt64}
    f = open("read.in", "r")
    L = parse(UInt64, readline(f))
    T = parse(Float64, readline(f))
    bins = parse(UInt64, readline(f))
    reps = parse(UInt64, readline(f))
    steps = parse(UInt64, readline(f))
    close(f)
    return L, T, bins, reps, steps
end