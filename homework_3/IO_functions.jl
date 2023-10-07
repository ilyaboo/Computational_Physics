function get_user_input()::Tuple{}
    # function that reads and returns simulation
    # parameters from user

    println("Enter alpha (inclination angle) in degrees:")
    alpha = parse(Float64, readline())

    println("Enter N_t (number of time steps in siderial day):")
    Nt = parse(UInt64, readline())

    println("Enter t_max (integration time) in seconds:")
    Nt = parse(UInt64, readline())

    println("Enter N_w (each how many steps the data will be recorded):")
    Nw = parse(UInt64, readline())

    return alpha, Nt, tmax, Nw
end