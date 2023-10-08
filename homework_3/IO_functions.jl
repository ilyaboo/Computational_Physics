function read_user_input()::Tuple{Float64, UInt64, UInt64, UInt64}
    # function that reads and returns simulation
    # parameters from user

    println("Enter alpha (inclination angle) in degrees:")
    alpha = parse(Float64, readline())

    println("Enter N_t (number of time steps in siderial day):")
    Nt = parse(UInt64, readline())

    println("Enter t_max (integration time) in seconds:")
    tmax = parse(UInt64, readline())

    println("Enter N_w (each how many steps the data will be recorded):")
    Nw = parse(UInt64, readline())

    return alpha, Nt, tmax, Nw
end

function run_simulation(alpha::Float64, Nt::UInt64, tmax::UInt64, Nw::UInt64)

    # initial coordinates of the satellite
    s_x::Float64 = rs
    s_y::Float64 = 0.0
    s_z::Float64 = 0.0

    # step counter for data recording
    step_counter::UInt64 = 0

    # current time
    t::Float64 = 0.0

    # number of rotations
    nr::UInt64 = 0

    # angles
    phi::Float64 = 0.0
    prev_phi::Float64 = 0.0

    # calculating time step
    dt::Float64 = Ts / Nt

    file = open("sat.dat", "w")

    # iterating until reach tmax
    while t <= tmax

        # incrementing step counter
        step_counter += 1

        # checking if should record this step
        if step_counter == Nw

            # resetting step counter
            step_counter = 0

            # calculating current angle phi
            phi = atan(s_y, s_x)

            # if produced a negative, convert to prositive
            if phi < 0.0
                phi = 2 * π + phi
            
            # if phi is positive and previous was negative
            # the full rotation was made
            elseif prev_phi < 0.0
                nr += 1
            end

            # updating previous phi
            prev_phi = phi

            # recording data
            println(file, 
                        t, " ", 
                        phi + 2 * π * nr, " ", 
                        phi + 2 * π * nr - 2 * π * t / Ts, " ", 
                        sqrt(s_x^2 + s_y^2 + s_z^2) - (G * Me * Ts^2 / (4 * π^2))^(1/3), " ",
                        atan(s_z, sqrt(s_x^2 + s_y^2)))
        
        # obtaining moon coordinates
        m_x, m_y, m_z = get_moon_pos(t, alpha)

        # using the net force equation to calculate acceleration components
        ax, ay, az = get_accelerations((s_x, s_y, s_z), (m_x, m_y, m_z))

        # using leapfrog algorithm to update satellite's coordinates
        s_x += ax * dt
        s_y += ay * dt
        s_z += az * dt

        # increasing time
        t += dt

    end

    close(file)
end