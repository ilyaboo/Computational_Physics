function read_user_input()::Tuple{Float64, Float64}
    # function that reads the radial step and maximum radius for
    # integration from the console

    println("Enter the radial step in fm: ")
    delta_r = parse(Float64, readline())

    println("Enter the maximum radius r_max in fm: ")
    r_max = parse(Float64, readline())

    return delta_r, r_max
end