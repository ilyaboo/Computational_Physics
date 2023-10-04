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

function conduct_series_integration(n_max::UInt64, N_0::UInt64, x_N::Float64, epsilon::Float64, alpha::Float64, scenario::Int64)
    # function that conducts series of integrations
    # according to user input and producing relevant output
    # recorded into text files
    # scenario variable is used for specific scenarios given in a problem to record
    # additional data
    # Scenario 1: epsilon = 1, alpha = 1/2, x_N = 1, N_0 = 10; exact_val = 0.82843
    # Scenario 2: epsilon = 0, alpha = 1/2, x_N = 1, N_0 = 10; excat_val = 2.0
    # Scenario 3: epsilon = 0, alpha = 3/4, x_N = 1, N_0 = 10; exactl_val = 4.0
    # Scenario 4: epsilon = 10^-5, alpha = 1/2, x_N = 1, N_0 = 10; exactl_val = 1.9937
    f1 = open("int_vals_1.txt", "w") # for valus produced by formula 1
    f2 = open("int_vals_2.txt", "w") # for valus produced by formula 2

    # array storing numbers of scenarios
    scenarios = [1, 2, 3, 4]

    # creating files for graphing data if one of the scenarios
    if scenario in scenarios
        graph_1 = open("graph_data_1.txt", "w")
        graph_2 = open("graph_data_2.txt", "w")
        delta_1 = Float64
        delta_2 = Float64
    end

    # headers
    println(f1, "N h ln(h) value")
    println(f2, "N h ln(h) value")

    # iterating over power values
    for n in 0:n_max

        # calculating the number of steps
        N::UInt64 = N_0 * 2^n

        # calculating discretization step
        h = discretization_step(x_N, N)

        # calculating the integral values
        I1::Float64 = first_order_integration(x_N, N, epsilon, alpha)
        I2::Float64 = second_order_integration(x_N, N, epsilon, alpha)

        # recording the integral values
        println(f1, N, " ", h, " ", log(h), " ", I1)
        println(f2, N, " ", h, " ", log(h), " ", I2)

        # if one of the scenarios, record data using exact value of the integral
        if scenario == 1

            # calculating deltas
            delta_1 = abs(I1 - 0.82843)
            delta_2 = abs(I2 - 0.82843)

        elseif scenario == 2

            # calculating deltas
            delta_1 = abs(I1 - 2.0)
            delta_2 = abs(I2 - 2.0)

        elseif scenario == 3

            # calculating deltas
            delta_1 = abs(I1 - 4.0)
            delta_2 = abs(I2 - 4.0)

        elseif scenario == 4

            # calculating deltas
            delta_1 = abs(I1 - 1.9937)
            delta_2 = abs(I2 - 1.9937)

        end

        if scenario in scenarios
            # recordong the results
            println(graph_1, log(h), " ", log(delta_1))
            println(graph_2, log(h), " ", log(delta_2))
        end
    end

    close(f1)
    close(f2)
end