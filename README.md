# ChairmarksForAirspeedVelocity

[![Build Status](https://github.com/LilithHafner/ChairmarksForAirspeedVelocity.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LilithHafner/ChairmarksForAirspeedVelocity.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LilithHafner/ChairmarksForAirspeedVelocity.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LilithHafner/ChairmarksForAirspeedVelocity.jl)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/C/ChairmarksForAirspeedVelocity.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/C/ChairmarksForAirspeedVelocity.html)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

This package allows folks to use benchmarks defined by
[Chairmarks.jl](https://github.com/LilithHafner/Chairmarks.jl) with
[AirspeedVelocity.jl](https://github.com/MilesCranmer/AirspeedVelocity.jl) even though
AirspeedVelocity expects benchmarks defined by
[BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl).

You might want to use this package to gain the performance of `Chairmarks.jl` while still
using the features of `AirspeedVelocity.jl`.

## Quick start tutorial

<!-- \/ Ensure that updates here are reflected in the "End to end tests" testset in runtests.jl \/ -->

Put this code in `benchmark/benchmarks.jl` and commit it to your `main` branch

```julia
using ChairmarksForAirspeedVelocity

const SUITE = BenchmarkGroup()

SUITE["main"]["random_sleep"] = @benchmarkable rand sleep evals = 1 samples = 2
```

Install `AirspeedVelocity.jl` with `julia -e 'using Pkg; Pkg.activate(temp=true); Pkg.add("AirspeedVelocity")'`

Navigate to your package directory and run
`~/julia/bin/benchpkg --add=https://github.com/LilithHafner/ChairmarksForAirspeedVelocity.jl --rev=dirty,main`

<!-- /\ Ensure that updates here are reflected in the "End to end tests" testset in runtests.jl /\ -->

## Explanation

`@benchmarkable ...` returns an object that masquerades as a `BenchmarkTools.Benchmark`. It
can be `BenchmarkTools.tune!`d (which is a no-op) and `run` (which runs `@be ...` and
lossily coerces the result into a `BenchmarkTools.Trial`).

A more idiomatic pattern would be `()->@b ...` but that would not support packages that
expect the BenchmarkTools API.

## Reference

See the [Chairmarks.jl documentation](https://chairmarks.lilithhafner.com/stable/)
for more information on `@be` and defining benchmarks and the
[AirspeedVelocity documentation](https://astroautomata.com/AirspeedVelocity.jl/stable/)
for more information on using `AirspeedVelocity.jl` to analyze benchmarks.
