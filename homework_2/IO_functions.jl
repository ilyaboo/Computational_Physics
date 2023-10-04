include("math_functions.jl")

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

function conduct_series_integration(n_max::UInt64, N_0::UInt64, x_N::Float64, epsilon::Float64, alpha::Float64)
    # function that conducts series of integrations
    # according to user input and producing relevant output
    # recorded into text files

    f1 = open("int_vals_1.txt", "w") # for valus produced by formula 1
    f2 = open("int_vals_2.txt", "w") # for valus produced by formula 2

    # iterating over power values
    for n in 0:n_max

        # calculating the number of steps
        N::UInt64 = N_0 * 2^n

        # recording the integral values
        println(f1, N, " ", first_order_integration(x_N, N, epsilon, alpha))
        println(f2, N, " ", second_order_integration(x_N, N, epsilon, alpha))
    end

    close(f1)
    close(f2)
end