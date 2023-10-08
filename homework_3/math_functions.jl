include("constants.jl")

function get_accelerations(rs::Tuple{Float64, Float64, Float64}, rm::Tuple{Float64, Float64, Float64})::Tuple{Float64, Float64, Float64}
    # function that calculates total gravitational force and uses
    # it to calculate accelerations of the satellite along the axis

    # extracting coordinates of the satellite
    s_x, s_y, s_z = rs

    # calculating the length of r_s
    rs_length = sqrt(s_x^2 + s_y^2 + s_z^2)

    # extracting coordinates of the Moon
    m_x, m_y, m_z = rm

    # calculating r_sm components
    sm_x = s_x - m_x
    sm_y = s_y - m_y
    sm_z = s_z - m_z

    # calculating the length of r_sm
    rsm_length = sqrt(sm_x^2 + sm_y^2 + sm_z^2)
    
    # calculating components of the acceleration
    ax::Float64 = -G * Me * s_x / rs_length^3 - G * Mm * sm_x / rsm_length^3
    ay::Float64 = -G * Me * s_y / rs_length^3 - G * Mm * sm_y / rsm_length^3
    az::Float64 = -G * Me * s_z / rs_length^3 - G * Mm * sm_z / rsm_length^3

    return ax, ay, az
end

function get_moon_pos(t::Float64, alpha::Float64)::Tuple{Float64, Float64, Float64}
    # function that given the time t and angle alpha returns
    # the coordinates of the Moon

    # converting alpha to radians
    alpha = alpha * π / 180
    
    r_x::Float64 = rm * cos(alpha) * cos(2 * π * t / Tm)
    r_y::Float64 = rm * sin(2 * π * t / Tm)
    r_z::Float64 = rm * sin(alpha) * cos(2 * π * t / Tm)

    return r_x, r_y, r_z
end