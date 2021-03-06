"""
Placeholder for a short summary about NumericalDebugging.
"""
module NumericalDebugging

using Requires: @require

export @check_if, nonfinite

"""
Whether to throw an error if a check fails (default: `false`).

Not exported, but part of the API.

# Example

```julia
julia> using NumericalDebugging

julia> NumericalDebugging.ERROR[] = true
true

julia> f() = @check_if nonfinite a = Inf
f (generic function with 1 method)

julia> f()
┌ Warning: nonfinite: Inf
│   a = Inf
└ @ Main REPL[18]:1
ERROR: nonfinite variables
```
"""
const ERROR = Ref(false)

####
#### macros
####

function _check_if(_module, _file, _line, f, label, kwargs)
    flagged_vars = collect(k for (k, v) in pairs(kwargs) if f(v))
    if !isempty(flagged_vars)
        @warn("$(label): $(flagged_vars...)",
              _module = _module, _file = _file, _line = _line,
              kwargs...)
        if ERROR[]
            error("$(label) variables")
        end
    end
    nothing
end

"""
    @check_if f arguments...

Check each argument, which is either a `variable` or a `symbol = value` pair, with `f`.

When `f` returns true for *any* argument, emit a warning with *all* values, also throw an
error when [`ERROR`](@ref) is set.

```jldoctest; filter = r"REPL.*"
julia> let a = Inf
           @check_if nonfinite a b = 9
       end
┌ Warning: nonfinite: a
│   a = Inf
│   b = 9
└ @ Main REPL[14]:2
```
"""
macro check_if(f, args...)
    file = String(__source__.file)
    line = __source__.line
    quote
        _check_if($__module__, $file, $line,
                  $f, $(string(f)), (; $(map(esc, args)...)))
    end
end

####
#### diagnostic functions
####

"""
    nonfinite(x)

Return true iff `x` is not finite, or has non-finite elements.
"""
nonfinite(x::Real) = !isfinite(x)

function nonfinite(x)
    if first(x) ≡ x             # catch Char, etc
        if x isa Real
            throw(DomainError())
        else
            false
        end
    else
        any(nonfinite, x)
    end
end

function __init__()
    @require ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210" begin
        import .ForwardDiff
        function NumericalDebugging.nonfinite(x::ForwardDiff.Dual)
            nonfinite(ForwardDiff.value(x)) || nonfinite(ForwardDiff.partials(x))
        end
    end
end

end # module
