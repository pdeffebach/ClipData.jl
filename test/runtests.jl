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
    """
    a b
    1 2
    3 4
    """ |> clipboard

    s = tablemwe(; returnstring=true)
    s_correct =
"""
df = \"\"\"
a,b
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File"""

    @test s == s_correct


    t = (a = [1, 3], b = [2, 4])
    s = tablemwe(t; returnstring = true)

    @test s == s_correct
end

@testset "arraymwe" begin
    """
    1 2
    3 4
    """ |> clipboard

    s = arraymwe(; returnstring=true)
    s_correct =
"""
X = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix"""

    @test s == s_correct


    t = [1 2; 3 4]
    s = arraymwe(t; returnstring = true)

    @test s == s_correct

    """
    1
    2
    3
    4
    """ |> clipboard

    s = arraymwe(; returnstring=true)

    s_correct =
"""
x = \"\"\"
1
2
3
4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix |> vec"""

    @test s == s_correct

    x = [1, 2, 3, 4]

    s = arraymwe(x; returnstring=true)
    @test s == s_correct
end

@testset "@tablemwe" begin
    # Can't think of a way to test. Just check
    # for errors.

    mytable = (a = [1, 2], b = [3, 4])

    @tablemwe mytable
end

@testset "@arraymwe" begin
    # Can't think of a way to test. Just check
    # for errors.

    myarray = [1 2; 3 4]

    @arraymwe myarray

    myvector = [1, 2, 3, 4]

    @arraymwe myvector
end


