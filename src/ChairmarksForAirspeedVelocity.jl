module ChairmarksForAirspeedVelocity

using Chairmarks
using BenchmarkTools: BenchmarkTools, BenchmarkGroup

export Chairmarks, @benchmarkable, BenchmarkGroup

"""
    Parameters(samples, evals)

A counterfeit `BenchmarkTools.Parameters` (missing some fields).
"""
struct Parameters
    samples::Int
    evals::Int
end

"""
    Trial(::Chairmarks.Benchmark)

A counterfeit `BenchmarkTools.Trial`.
"""
struct Trial
    params::Parameters
    times::Vector{Float64}
    gctimes::Vector{Float64}
    memory::Int
    allocs::Int
end

function Trial(b::Chairmarks.Benchmark)
    s = b.samples
    isempty(s) && throw(ArgumentError("Benchmark has no samples"))
    allequal(s.evals for s in s) || throw(ArgumentError("Not all samples have the same number of evaluations"))
    allequal(s.allocs for s in s) || throw(ArgumentError("Not all samples have the same number of allocations"))
    allequal(s.bytes for s in s) || throw(ArgumentError("Not all samples have the same memory usage"))
    times = getproperty.(s, :time) .* 1e9
    s1 = first(s)
    Trial(Parameters(length(s), s1.evals), times, getproperty.(s, :gc_fraction) .* times, s1.bytes, s1.allocs)
end
function Base.show(io::IO, t::Trial)
    if get(io, :typeinfo, nothing) != Trial
        print(io, Trial, '(')
    end
    Chairmarks.print_time(io, minimum(t.times)/1e9)
    if get(io, :typeinfo, nothing) != Trial
        print(io, ')')
    end
end

"""
    Runnable(f) <: Function

Calling `run(Runnable(f); kwargs...)` will run `f()`.
Calling `BenchmarkTools.tune!(::Runnable; kwargs)` will return `nothing`
Calling `(r::Runnable)()` will run `f()`.

This type exists to allow functions to be passed both to tools that expect functions and
to tools built to support BenchmarkTools.jl.
"""
struct Runnable{F} <: Function
    f::F
end
Base.run(r::Runnable; kwargs...) = r.f()
(r::Runnable)() = r.f()
BenchmarkTools.tune!(::Runnable; kwargs...) = nothing

"""
    @benchmarkable args...

Like `()->@be args...`, but compatible with tools built to support BenchmarkTools.jl.

"""
macro benchmarkable(args...)
    :(Runnable(()->Trial(@be $(args...))))
end


end
