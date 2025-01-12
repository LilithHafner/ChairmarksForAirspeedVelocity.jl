module ChairmarksForAirspeedVelocity

using Chairmarks
using BenchmarkTools: BenchmarkTools, BenchmarkGroup

export Chairmarks, @benchmarkable, BenchmarkGroup

"""
    make_trial(::Chairmarks.Benchmark) -> BenchmarkTools.Trial

Lossily convert a `Chairmarks.Benchmark` to a `BenchmarkTools.Trial`.

Information stored by `Chairmarks.Benchmark` that is not stored by `BenchmarkTools.Trial` is
discarded. Information stored by `BenchmarkTools.Trial` that is not stored by
`Chairmarks.Benchmark` is populated with null values (`NaN` for float, `false` for boolean)
or with BenchmarkTools' defaults.
"""
function make_trial(b::Chairmarks.Benchmark)
    s = b.samples
    isempty(s) && throw(ArgumentError("Benchmark has no samples"))
    allequal(s.evals for s in s) || throw(ArgumentError("Not all samples have the same number of evaluations"))
    allequal(s.allocs for s in s) || throw(ArgumentError("Not all samples have the same number of allocations"))
    allequal(s.bytes for s in s) || throw(ArgumentError("Not all samples have the same memory usage"))
    times = getproperty.(s, :time) .* 1e9
    s1 = first(s)
    BenchmarkTools.Trial(
        BenchmarkTools.Parameters(
            seconds=NaN,
            samples=length(s),
            evals=s1.evals,
            overhead=0,
            gctrial=false,
            gcsample=false),
        times,
        getproperty.(s, :gc_fraction) .* times,
        s1.bytes,
        s1.allocs)
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
    :(Runnable(()->make_trial(@be $(args...))))
end


end
