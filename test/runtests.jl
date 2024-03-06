using ClipData
using Test
using InteractiveUtils: clipboard
using Tables

const ≅ = isequal

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

@testset "Kwargs with reading" begin
    """
    a,b
    1,2
    3,NA
    """ |> clipboard
    t = cliptable(; missingstring = "NA") |> Tables.columntable
    @test t ≅ (; a = [1, 3], b = [2, missing])

    """
    a\tb
    1\t2
    3\t4
    # a comment
    """ |> clipboard
    t = cliptable(; comment = "#") |> Tables.columntable
    @test t == (; a = [1, 3], b = [2, 4])

    """
    a,b
    1,2
    3,NA
    """ |> clipboard
    t = cliptable(; limit = 1, header = true) |> Tables.columntable
    @test t == (; a = [1], b = [2])

    """
    1,2
    3,NA
    """ |> clipboard
    a = cliparray(; missingstring = "NA")
    @test a ≅  [1 2; 3 missing]
end

@testset "Kwargs with writing" begin
    t = (a = [1, 2], b = [3, 4])
    cliptable(t; delim = ",")
    @test clipboard() == "a,b\n1,3\n2,4"

    cliptable(t; header = ["x", "y"])
    @test clipboard() == "x\ty\n1\t3\n2\t4"

    t = (a = [1.0, missing], b = [3, 4])
    cliptable(t; missingstring = "NA", decimal = ',')

    @test clipboard() == "a\tb\n1,0\t3\nNA\t4"

    t = (a = [1, nothing], b = [missing, 4])
    cliptable(t, missingstring="-1", transform=(col, val) -> something(val, missing))

    @test clipboard() == "a\tb\n1\t-1\n-1\t4"
end


