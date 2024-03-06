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

    """
    1 2 3 4
    """ |> clipboard

    @test cliparray() == [1, 2, 3, 4]
end

@testset "mwetable" begin
    """
    a b
    1 2
    3 4
    """ |> clipboard

    s = mwetable(; returnstring=true)
    s_correct =
"""
df = \"\"\"
a,b
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File"""

    @test s == s_correct

    t = (a = [1, 3], b = [2, 4])
    s = mwetable(t; returnstring = true)
    @test s == s_correct

    # Tests the default printing to stdout
    io = IOBuffer()
    mwetable(io, t; returnstring=false)
    @test String(take!(io)) == s_correct

    io = IOBuffer()
    cliptable(t)
    mwetable(io; returnstring=false)
    @test String(take!(io)) == s_correct
end

@testset "mwearray" begin
    """
    1 2
    3 4
    """ |> clipboard

    s = mwearray(; returnstring=true)
    s_correct =
"""
X = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix"""

    @test s == s_correct

    t = [1 2; 3 4]
    s = mwearray(t; returnstring = true)

    @test s == s_correct

    io = IOBuffer()
    mwearray(io, t; returnstring=false)
    @test String(take!(io)) == s_correct

    io = IOBuffer()
    cliparray(t)
    mwearray(io)
    @test String(take!(io)) == s_correct

    """
    1
    2
    3
    4
    """ |> clipboard

    s = mwearray(; returnstring=true)

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

    s = mwearray(x; returnstring=true)
    @test s == s_correct

    # Tests the default printing to stdout
    io = IOBuffer()
    mwearray(io, x; returnstring=false)
    @test String(take!(io)) == s_correct

    io = IOBuffer()
    cliparray(x)
    mwearray(io)
    @test String(take!(io)) == s_correct

end

@testset "@mwetable" begin
    # Can't think of a way to test. Just check
    # for errors.

    mytable = (a = [1, 2], b = [3, 4])

    @mwetable mytable
end

@testset "@mwearray" begin
    # Can't think of a way to test. Just check
    # for errors.

    myarray = [1 2; 3 4]

    @mwearray myarray

    myvector = [1, 2, 3, 4]

    @mwearray myvector
end


