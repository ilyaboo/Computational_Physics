function read_input()::Tuple{Float64, UInt64, UInt64}
    # function that reads the upper bound (x_N),
    # base value (N_0) and maximum power (n_max)
    # from a user in the terminal

    println("Enter x_N value:")
    x_N = parse(Float64, readline())

    println("Enter N_0 value:")
    N_0 = parse(UInt64, readline())

    println("Enter n_max value:")
    n_max = parse(UInt64, readline())

    return (x_N, N_0, n_max)
end