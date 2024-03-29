include("math_functions.jl")

function read_user_input()::Tuple{Float64, Float64}
    # function that reads the radial step and maximum radius for
    # integration from the console

    println("Enter the radial step in fm: ")
    delta_r = parse(Float64, readline())

    println("Enter the maximum radius r_max in fm: ")
    r_max = parse(Float64, readline())

    return delta_r, r_max
end

function write_results(r_max::Float64, delta_r::Float64)
    # function which computes and records
    # values of V0 and r for a range of values
    # of a into the vr.dat file

    file = open("vr.dat", "w")

    for a in 0.5:0.01:3.0
        V0 = find_bound_state(a, 0.001, r_max, delta_r)
        r2 = compute_radius(V0, delta_r, r_max, a)
        println(file, a, ",", V0, ",", r2)
    end

    close(file)
end