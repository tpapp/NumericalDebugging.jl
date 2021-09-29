using NumericalDebugging, Test, ForwardDiff

@testset "nonfinite" begin
    @test nonfinite(Inf)
    @test nonfinite(NaN)
    @test !nonfinite(-9)
    @test !nonfinite("a fish")
    @test nonfinite([1.0, Inf])
    @test !nonfinite([1.0, 2.0])
    @test nonfinite(ForwardDiff.Dual(1.0, Inf))
    @test nonfinite(ForwardDiff.Dual(NaN, 1.0))
    @test !nonfinite(ForwardDiff.Dual(0.0, 1.0))
end

let a = Inf
    @test_logs (:warn, "nonfinite: a") @check_if nonfinite a b = 9
    NumericalDebugging.ERROR[] = true
    @test_throws Exception @check_if nonfinite a
end
