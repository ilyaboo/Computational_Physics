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