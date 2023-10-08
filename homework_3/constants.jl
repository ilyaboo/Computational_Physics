# constant values in SI units

const G = 6.6743 * 10^-11   # Gravitational constant
const Me = 5.9736 * 10^24   # Earth's mass
const Mm = 7.3477 * 10^22   # Moon's mass
const GMe = 3.9870 * 10^14   # product G * Me to avoid calculations with large value of G
const GMm = 1.23 * 10^-2 * GMe   # product G * Mm to avoid calculations with large value of G
const Rs = (GMe * Ts^2 / 4 / π^2)^(1/3)   # radius of the orbit of the satellite
const Rm = 384400 * 10^3   # distance from moon to Earth's center
const Ts = 86164   # length of siderial day 
const Tm = 27.25 * Ts   # period for the Moon