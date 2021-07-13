# NumericalDebugging.jl

![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
[![build](https://github.com/tpapp/NumericalDebugging.jl/workflows/CI/badge.svg)](https://github.com/tpapp/NumericalDebugging.jl/actions?query=workflow%3ACI)
[![codecov.io](http://codecov.io/github/tpapp/NumericalDebugging.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/NumericalDebugging.jl?branch=master)

Minimal package for numerical debugging.

## Installation

This package is currently *unregistered*. This should not be a probem in practice, as it is meant for transient use. Install with

```julia
pkg> add https://github.com/tpapp/NumericalDebugging.jl
```

## Usage

```julia
julia> using NumericalDebugging
[ Info: Precompiling NumericalDebugging [ee34e48c-26bf-497e-93c0-4433ee141562]

julia> @check_if nonfinite a = Inf b = 9
┌ Warning: nonfinite: a
│   a = Inf
│   b = 9
└ @ Main REPL[42]:1
```
