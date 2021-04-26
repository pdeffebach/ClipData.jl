using ClipData
using Test
using InteractiveUtils: clipboard
using Tables

@testset "cliptable" begin
    """
    a b
    1 2
    3 4
    """ |> clipboard

    @test Tables.columntable(cliptable()) == (a = [1, 3], b = [2, 4])

    """
    a\tb
    1\t2
    3\t4
    """ |> clipboard

    @test Tables.columntable(cliptable()) == (a = [1, 3], b = [2, 4])

    t = (a = [1, 3], b = [2, 4])
    cliptable(t)
    @test clipboard() == "a\tb\n1\t2\n3\t4"
end

@testset "cliparray" begin
    """
    1 2
    3 4
    """ |> clipboard

    @test cliparray() == [1 2; 3 4]

    """
    1\t2
    3\t4
    """ |> clipboard

    @test cliparray() == [1 2; 3 4]

    """
    1
    2
    3
    4
    """ |> clipboard

    @test cliparray() == [1, 2, 3, 4]

    X = [1 2; 3 4]
    cliparray(X)
    @test clipboard() == "1\t2\n3\t4"

    x = [1, 2, 3, 4]
    cliparray(x)
    @test clipboard() == "1\n2\n3\n4"
end

@testset "tablemwe" begin

end

@testset "arraymwe" begin

end

@testset "@tablemwe" begin

end

@testset "@arraymwe" begin

end


