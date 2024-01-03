function f(x::Float64, epsilon::Float64, alpha::Float64)::Float64
    # function that is used in the assignment
    return 1 / (epsilon + x)^alpha
end

function discretization_step(x_N::Float64, N::UInt64)::Float64
    # helper function that returns the discretization step
    # calculating it from upper bound and number of steps
    # (assuming lower bound is zero)
    return x_N / N
end

function first_order_integration(x_N::Float64, N::UInt64, epsilon::Float64, alpha::Float64)::Float64
    # function that given the parameters needed for integration returns the
    # value of the first order integral according to the formula

    # calculating the discretization step
    h::Float64 = discretization_step(x_N, N)


    # calculating the sum of the components
    result::Float64 = 3/2 * f(h, epsilon, alpha) + 3/2 * f(h * (N - 1), epsilon, alpha)
    for i in 2:(N - 2)
        result += f(i * h, epsilon, alpha)
    end

    # returning the result multiplied by the step
    return h * result
end

function second_order_integration(x_N::Float64, N::UInt64, epsilon::Float64, alpha::Float64)::Float64
    # function that given the parameters needed for integration returns the
    # value of the second order integral according to the formula

    # calculating the discretization step
    h::Float64 = discretization_step(x_N, N)


    # calculating the sum of the components
    result::Float64 = 23/12 * f(h, epsilon, alpha) + 23/12 * f(h * (N - 1), epsilon, alpha) + 
                        7/12 * f(2 * h, epsilon, alpha) + 7/12 * f(h * (N - 2), epsilon, alpha)
    for i in 3:(N - 3)
        result += f(i * h, epsilon, alpha)
    end

    # returning the result multiplied by the step
    return h * result
end

function is_inside_sphere(x::Float64, y::Float64, z::Float64, r::Float64)::Bool
    # helper function that veryfies whether a point (x, y, z) is in a spefere
    # or radius r
    return x^2 + y^2 + z^2 <= r^2
end

function is_inside_cylinder(x::Float64, y::Float64, r::Float64)::Bool
    # helper function that veryfies whether a point with x and y coordinates
    # is inside a cylinder of radius r given it is in the sphere of radius r
    return x^2 + y^2 <= r^2
end

function added_inertia(x::Float64, y::Float64, z::Float64, r_cylinder::Float64, rho1::Float64, rho2::Float64)::Tuple{Float64, Float64}
    # function that computes the addition to the inertia given the point is in the sphere
    
    # calculating distance to the axis of rotation for x-axis and z-axis
    distance_x_sqaured::Float64 = y^2 + z^2
    distance_z_squared::Float64 = x^2 + y^2
    
    # checking if the point is in cylinder and using appropriate density
    if is_inside_cylinder(x, y, r_cylinder)
        return rho2 * distance_x_sqaured, rho2 * distance_z_squared
    else
        return rho1 * distance_x_sqaured, rho1 * distance_z_squared
    end
end