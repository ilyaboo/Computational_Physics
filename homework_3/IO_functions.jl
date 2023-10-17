include("constants.jl")

function read_user_input()::Tuple{Float64, UInt64, UInt64, UInt64}
    # function that reads and returns simulation
    # parameters from user

    println("Enter alpha (inclination angle) in degrees:")
    alpha = parse(Float64, readline())

    println("Enter N_t (number of time steps in siderial day):")
    Nt = parse(UInt64, readline())

    println("Enter t_max (integration time) in days:")
    tmax = parse(UInt64, readline())
    tmax = tmax * T0

    println("Enter N_w (each how many steps the data will be recorded):")
    Nw = parse(UInt64, readline())

    return alpha, Nt, tmax, Nw
end

function run_simulation(alpha::Float64, Nt::UInt64, tmax::UInt64, Nw::UInt64)

    # initial coordinates of the satellite
    s_x::Float64 = Rs
    s_y::Float64 = 0.0
    s_z::Float64 = 0.0

    # initial velocity components of the satellite
    v_x::Float64 = 0.0
    v_y::Float64 = sqrt(GMe / Rs)
    v_z::Float64 = 0.0

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
    dt::Float64 = T0 / Nt

    file = open("sat.dat", "w")

    # iterating until reach tmax
    while t <= tmax

        # incrementing step counter
        step_counter += 1

        # calculating current angle phi
        phi = atan(s_y, s_x)

        # if produced a negative, convert to prositive
        if phi < 0.0
            phi = 2 * π + phi
        end
        
        # if phi is smaller than the previous one,
        # one rotation was made
        if prev_phi > phi
            nr += 1
        end

        # updating previous phi
        prev_phi = phi

        # checking if should record this step
        if step_counter == Nw

            # resetting step counter
            step_counter = 0

            # recording data
            println(file, 
                        t, " ", 
                        phi + 2 * π * nr, " ", 
                        sqrt(s_x^2 + s_y^2 + s_z^2), " ", 
                        phi + 2 * π * nr - 2 * π * t / Ts, " ", 
                        sqrt(s_x^2 + s_y^2 + s_z^2) - (GMe * Ts^2 / (4 * π^2))^(1/3), " ",
                        atan(s_z, sqrt(s_x^2 + s_y^2)))
        end

        # obtaining moon coordinates
        m_x, m_y, m_z = get_moon_pos(t, alpha)

        # using the net force equation to calculate acceleration components
        ax, ay, az = get_accelerations((s_x, s_y, s_z), (m_x, m_y, m_z))

        # using leapfrog algorithm to update satellite's velocity components halfway through dt
        v_x += 0.5 * ax * dt
        v_y += 0.5 * ay * dt
        v_z += 0.5 * az * dt

        # updating position components
        s_x += v_x * dt
        s_y += v_y * dt
        s_z += v_z * dt

        # increasing time
        t += dt

        # obtaining accelerations for new position
        m_x, m_y, m_z = get_moon_pos(t, alpha)
        ax, ay, az = get_accelerations((s_x, s_y, s_z), (m_x, m_y, m_z))

        # updating velocities for the end of dt
        v_x += 0.5 * ax * dt
        v_y += 0.5 * ay * dt
        v_z += 0.5 * az * dt

    end

    close(file)
end