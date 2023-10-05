include("math_functions.jl")
using Random

function read_input_1()::Tuple{Float64, UInt64, UInt64}
    # reading input for the first task
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

function read_input_2()::Tuple{Float64, Float64, Float64, Float64, UInt64, UInt64}
    # function that reads input for Monte Carlo integration from read.in

    file = open("read.in", "r")
    line1 = readline(file)
    line2 = readline(file)
    line3 = readline(file)
    line4 = readline(file)
    line5 = readline(file)
    line6 = readline(file)
    close(file)

    r1 = parse(Float64, line1)
    r2 = parse(Float64, line2)
    rho1 = parse(Float64, line3)
    rho2 = parse(Float64, line4)
    npt = parse(UInt64, line5)
    nbi = parse(UInt64, line6)

    return r1, r2, rho1, rho2, npt, nbi
end

function run_monte_carlo_integration(r1::Float64, r2::Float64, rho1::Float64, rho2::Float64, npt::UInt64, nbi::UInt64)
    # function that runs the monte carlo integration and
    # records the results

    file_bins = open("bin.dat", "w")
    file_res = open("res.dat", "w")

    # sphere volume for future calculations
    sphere_volume = 4/3 * π * r1^3

    # bin results
    bin_data = []

    # iterating over bins
    for bin in 1:nbi

        # recording inertia totals
        bin_Ix::Float64 = 0.0
        bin_Iz::Float64 = 0.0

        # counting number of point generated
        bin_points_counter::UInt64 = 0

        while bin_points_counter != npt

            # generating ranomd coordinates
            x::Float64 = r1 * (2 * rand() - 1)
            y::Float64 = r1 * (2 * rand() - 1)
            z::Float64 = r1 * (2 * rand() - 1)

            # checking if the point is in the sphere
            if is_inside_sphere(x, y, z, r1)

                # incrementing the number of points recorded
                bin_points_counter += 1

                # calculating additions to inertias
                delta_Ix, delta_Iz = added_inertia(x, y, z, r2, rho1, rho2)

                # adding to total inertias
                bin_Ix += delta_Ix
                bin_Iz += delta_Iz
            end
        end

        # calculating Ix and Iz for the bin
        bin_average_Ix = sphere_volume * bin_Ix / npt
        bin_average_Iz = sphere_volume * bin_Iz / npt

        # recording bin averages
        println(file_bins, bin, " ", bin_average_Iz, " ", bin_average_Ix)

        # adding results to the array
        push!(bin_data, (bin_average_Ix, bin_average_Iz))
    
    end

    # calculating final average and error bar 
    final_average_Ix = sum([val[1] for val in bin_data]) / nbi
    final_average_Iz = sum([val[2] for val in bin_data]) / nbi

    # calculating standard deviations of the means
    std_Ix = sqrt(sum([(val[1] - final_average_Ix)^2 for val in bin_data]) / nbi)
    std_Iz = sqrt(sum([(val[2] - final_average_Iz)^2 for val in bin_data]) / nbi)

    # recording results 
    println(file_res, "z: ", final_average_Iz, " ", std_Iz)
    println(file_res, "x: ", final_average_Ix, " ", std_Ix)

    close(file_bins)
    close(file_res)
end