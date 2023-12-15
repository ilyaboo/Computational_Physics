"""
function which generates the connectivity table (sites connected by interactions)
"""
function sitetable(nn::Int)
   nb = div(nn * (nn -1 ), 2)
   sites = Array{Int}(undef, 2, nb)
   b = 0
   for i = 0:nn - 1
      for j = 0:i - 1
         b = b + 1
         sites[1, b] = i
         sites[2, b] = j
      end
   end

   return sites
end

"""
function which constructs vector with the ising energies for each basis state
"""
function ising(nn::Int, sites)
   nb = div(nn * (nn - 1), 2)
   hzz = Vector{Float64}(undef, 2^nn)
   for a = 0:2^nn - 1
      ez::Float64 = 0
      for i = 1:nb
         s1 = a & (1 << sites[1, i])
         s2 = a & (1 << sites[2, i])

         if (s1 == 0 && s2 == 0) || s1 != 0 && s2 != 0
            ez = ez - 1
         else
            ez = ez + 1
         end

      end

      hzz[a + 1]=2 * ez / (nn - 1)
   end

   return hzz
end

"""
function which constructs vector with the ising energies for each basis state
using the random couplings provided
"""
function ising_with_couplings(nn::Int, sites, couplings)
   nb = div(nn * (nn - 1), 2)
   hzz = Vector{Float64}(undef, 2^nn)
   for a = 0:2^nn - 1
      ez::Float64 = 0
      for i = 1:nb
         s1 = a & (1 << sites[1, i])
         s2 = a & (1 << sites[2, i])

         # obtaining the coupling value for this pair of sites
         Jij = couplings[i]

         if (s1 == 0 && s2 == 0) || s1 != 0 && s2 != 0
            ez = ez - Jij
         else
            ez = ez + Jij
         end

      end

      hzz[a + 1]=2 * ez / (nn - 1)
   end

   return hzz
end

"""
function which initializes the state vector to all equal elements (x magnetized)
"""
function initstate(nn::Int)
   psi = Vector{Complex}(undef, 2^nn)
   psi .= 1
   psi .= psi ./ sqrt(sum(abs2.(psi)))
   return psi
end

"""
function which acts with H(J,h) on f0, producing f1
"""
function hoperation(nn::Int, hh::Float64, jj::Float64, hzz, f0, f1)
   b::Int = 0
   f1 .= jj .* hzz .* f0     
   for a = 0:2^nn - 1
      for i = 0:nn - 1
         b = xor(a, 1 << i)
         f1[b + 1] += -hh * f0[a + 1]
      end
   end
end

"""
function which uses the RK method to integrate the Schrodinger equation by one time step dt
"""
function timestep(nn::Int, ss::Float64, ds::Float64, dt::Float64, hzz, psi, f0, f1, f2)
   jj::Float64 = ss
   hh::Float64 = 1 - ss
   dj::Float64 = 0.5 * ds
   dh::Float64 = -dj
   @. f2=psi
   @. f0=psi
   hoperation(nn, hh, jj, hzz, f0, f1)
   @. f1 = -dt * im .* f1
   @. f2 = f2 + f1 / 6
   @. f0 = psi + 0.5 * f1
   hoperation(nn, hh + dh, jj + dj, hzz, f0, f1)
   @. f1 = -dt * im * f1
   @. f2 = f2 + f1 / 3
   @. f0 = psi + 0.5 * f1
   hoperation(nn, hh + dh, jj + dj, hzz, f0, f1)
   @. f1 = -dt * im * f1
   @. f2 = f2 + f1 / 3
   @. f0 = psi + f1
   hoperation(nn, hh + 2 * dh, jj + 2 * dj, hzz, f0, f1)
   @. f1 = -dt * im * f1
   @. f2 = f2 + f1 / 6
   psi .= f2 ./ sqrt(sum(abs2.(f2)))  # Normalize, since RK isn't fully unitary
end

"""
function which carries out a complete quantum annealing from h = 1, J = 0 to h = 0, J = 1
"""
function anneal(nn::Int, tt::Float64, nt::Int, wf::Int, hzz)
   f0 = Vector{Complex}(undef, 2^nn)
   f1 = Vector{Complex}(undef, 2^nn)
   f2 = Vector{Complex}(undef, 2^nn)
   sdata = Array{Float64}(undef, 2, div(nt, wf))
   psi = initstate(nn)   
   ds::Float64 = 1 / nt
   dt::Float64 = tt / nt
   for t = 0:nt - 1
      ss::Float64 = t / nt 
      timestep(nn, ss, ds, dt, hzz, psi, f0, f1, f2)
      if mod(t + 1, wf) == 0 
         w = div(t + 1, wf)
         sdata[1, w] = 2 * abs2(psi[1])
         sdata[2, w] = sum(hzz .* abs2.(psi)) - hzz[1]
      end
   end

   return sdata
end

"""
function which generates couplings that follow given distribution
"""
function generate_random_couplings(nn::Int, a::Float64)

   # creating an array wto return
   sites = sitetable(nn)
   couplings = Array{Float64}(undef, size(sites, 2))

   # iterating over couplings
   for i in 1:length(couplings)

      # randomly generating the sign according to the probability
      sign = rand() < a ? -1 : 1

      # randomly generating the magnitude
      magnitude = rand()

      # recording the results
      couplings[i] = sign * magnitude
   end

   return couplings
end

# reading the input
file = open("read.in", "r")
   nn = parse(Int, readline(file))      # system size (number of spins)
   a = parse(Float64, readline(file))   # probability parameter a
   tt = parse(Float64, readline(file))  # Annealing time from s=0 to s=1
   nt = parse(Int, readline(file))      # number of time steps
   wf = parse(Int, readline(file))      # save results every wf time step
   bins = parse(Int, readline(file))    # number of bins
   reps = parse(Int, readline(file))    # number of random instances of the couplings to be run for each bin
close(file)


file = open("res.dat", "w")

# iteraing over bins
for bin in 1:bins

   # creating an array for bin results
   bin_results = zeros(Float64, 2, div(nt, wf))

   # creating an array for square sum for error calculations
   bin_results_sq = zeros(Float64, 2, div(nt, wf))

   # iterating over reps for the bin
   for rep in 1:reps

      # generating new random couplings for this realization
      sites = sitetable(nn)
      random_couplings = generate_random_couplings(nn, a)
      hzz = ising_with_couplings(nn, sites, random_couplings)

      # performing the annealing simulation
      sdata = anneal(nn, tt, nt, wf, hzz)

      # recording the results of the realization
      bin_results .+= sdata

      # recording the squares of the data
      bin_results_sq .+= sdata .^ 2
   end

   # computing bin averages
   bin_averages = bin_results / reps

   # calculating standard errors
   bin_errors = sqrt.(abs.(bin_results_sq / reps - bin_averages .^ 2) / (reps - 1))

   # writing bin averages to the file
   for i in 1:div(nt, wf)

      s = i / div(nt, wf)
      println(file, s, "  ", bin_averages[1, i], "  ", bin_averages[2, i])
  end
end

close(file)



"""
sites = sitetable(nn)
hzz = ising(nn, sites)
sdata = anneal(nn, tt, nt, wf, hzz)
file = open("s.dat", "w")
for i = 1:div(nt, wf)
   s = i / div(nt, wf)
   println(file, s, "  ", sdata[1, i], "  ", sdata[2, i])
end
close(file)
"""