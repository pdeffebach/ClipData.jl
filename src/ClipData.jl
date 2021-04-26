module ClipData

using CSV, Tables

using InteractiveUtils: clipboard

export cliptable, cliparray, tablemwe, arraymwe, @tablemwe, @arraymwe

"""
    cliptable(; kwargs...)

Make a table from the clipboard. Returns
a `CSV.File`, which can then be transformed
into a `DataFrame` or other Tables.jl-compatible
object.

`cliptable` auto-detects delimiters, and all keyword
arguments are passed directly to the `CSV.File`
constructor.

## Examples

```Julia
julia> # Send string to the clipboard
       \"\"\"
       a, b
       1, 2
       100, 200
       \"\"\" |> clipboard

julia> cliptable()
2-element CSV.File{false}:
 CSV.Row: (a = 1,  b = 2)
 CSV.Row: (a = 100,  b = 200)
```

"""
function cliptable(; kwargs...)
    CSV.File(IOBuffer(clipboard()); kwargs...)
end

"""
    cliparray(; kwargs...)

Make a `Vector` or `Matrix` from the clipboard.
Auto-detects delimiters, and all keyword arguments are passed
directly to a `CSV.File` constructor. If the returned `CSV.File`
has one column, `cliparray` returns a `Vector`. Otherwise, it returns
a `Matrix`.

# Examples

julia> # Send string to clipboard
       \"\"\"
       1 2
       3 4
       \"\"\" |> clipboard

julia> cliparray()
2×2 Matrix{Int64}:
 1  2
 3  4

julia> \"\"\"
       1
       2
       3
       4
       \"\"\" |> clipboard

julia> cliparray()
4-element Vector{Int64}:
 1
 2
 3
 4

"""
function cliparray(; kwargs...)
    t = CSV.File(IOBuffer(clipboard()); header=false, kwargs...)
    mat = Tables.matrix(t)
    if size(mat, 2) > 1
        return mat
    else
        return vec(mat)
    end
end

"""
    cliptable(t; delim = , kwargs...)

Send a Tables.jl-compatible object to the clipboard.
Default delimiter is tab. Accepts all keyword arguments
that can be pased to `CSV.write`.

# Example

```julia
julia> t = (a = [1, 2, 3], b = [100, 200, 300])
(a = [1, 2, 3], b = [100, 200, 300])

julia> cliptable(t)
a   b
1   100
2   200
3   300
```
"""
function cliptable(t; returnstring = false, delim = '\t', kwargs...)
    io = IOBuffer()
    CSV.write(io, t, delim = delim, kwargs...)
    s = chop(String(take!(io)), tail = 1)
    clipboard(s)
    println(s)

    if returnstring == true
      return s
    else
      return nothing
    end
end

"""
    cliparray(t::AbstractVecOrMat; kwargs...)

Send a `Vector` or `Matrix` to the clipboard.
Default delimiter is tab and with no header.
Accepts all keyword arguments that can be passed
to `CSV.write`.

# Examples

```julia
julia> \"\"\"
       1 2
       3 4
       \"\"\" |> clipboard

julia> cliparray()
2×2 Matrix{Int64}:
 1  2
 3  4
```
"""
function cliparray(t::AbstractVecOrMat; returnstring = false, delim='\t',
                   header=false, kwargs...)
    if t isa AbstractVector
        t = reshape(t, :, 1)
    end
    io = IOBuffer()
    CSV.write(io, Tables.table(t); delim=delim, header=header, kwargs...)
    s = chop(String(take!(io)), tail = 1)
    clipboard(s)
    println(s)

    if returnstring == true
      return s
    else
      return nothing
    end
end

"""
    tablemwe(; name="df")

Create a Minimum Working Example (MWE) using
the clipboard. `tablmwe` prints out a multi-line
comma-separated string and provides the necessary
code to read that string using `CSV.File`.
The object is assigned the name given by
`name` (default `"df"`).

# Examples

```julia
julia> \"\"\"
       a b
       1 2
       100 200
       \"\"\" |> clipboard

julia> tablemwe()
df = \"\"\"
a,b
1,2
100,200
\"\"\" |> IOBuffer |> CSV.File
```

"""
function tablemwe(; returnstring=false, name="df")
    t = cliptable()
    tablemwe(t, returnstring=returnstring, name=name)
end

"""
    tablemwe(t; name="df")

Create a Minimum Working Example (MWE) from
an existing Tables.jl-compatible object.
`tablmwe` prints out a multi-line
comma-separated string and provides the necessary
code to read that string using `CSV.File`.
The object is assigned the name given by
`name` (default `:df`).

# Examples

```julia
julia> t = (a = [1, 2, 3], b = [100, 200, 300])
(a = [1, 2, 3], b = [100, 200, 300])

julia> tablemwe(t)
df = \"\"\"
a,b
1,100
2,200
3,300
\"\"\" |> IOBuffer |> CSV.File
```
"""
function tablemwe(t; returnstring=false, name="df")
    main_io = IOBuffer()
    table_io = IOBuffer()

    start_str = """
$name = \"\"\"
"""
    print(main_io, start_str)

    CSV.write(table_io, t;)
    print(main_io, String(take!(table_io)))

    end_str = """
\"\"\" |> IOBuffer |> CSV.File"""
    print(main_io, end_str)
    s = String(take!(main_io))
    println(s)

    if returnstring == true
      return s
    else
      return nothing
    end
end

function tablemwe_helper(t::Symbol)
    t_name = QuoteNode(t)
    :(tablemwe($t, name = $t_name))
end

"""
    @tablemwe(t)

Create a Minimum Working Example (MWE) from
an existing Tables.jl-compatible object.
`tablmwe` prints out a multi-line
comma-separated string and provides the necessary
code to read that string using `CSV.File`. The name
assigned to the object in the MWE is the
same as the name of the input object.

# Examples

```julia
julia> my_special_table = (a = [1, 2, 3], b = [100, 200, 300])
(a = [1, 2, 3], b = [100, 200, 300])

julia> @tablemwe my_special_table
my_special_table = \"\"\"
a,b
1,100
2,200
3,300
\"\"\" |> IOBuffer |> CSV.File
```
"""
macro tablemwe(t)
    esc(tablemwe_helper(t))
end

"""
    arraymwe(; name=:X)

Create a Minimum Working Example (MWE) from
the clipboard to create an array. `arraymwe`
returns the a multi-line string with the
code necessary to read the string stored in
clipboard as a `Vector` or `Matrix`.

# Examples

```julia
julia> \"\"\"
       1 2
       3 4
       \"\"\" |> clipboard

julia> arraymwe()
X = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix
```
"""
function arraymwe(; returnstring=false, name=nothing)
    t = cliparray()
    name= t isa AbstractVector ? :x : :X
    arraymwe(t, returnstring=returnstring, name=name)
end

"""
    arraymwe(t::AbstractMatrix; name=:X)

Create a Minimum Working Example (MWE) from
a `Matrix`. `arraymwe`
returns the a multi-line string with the
code necessary to recreate `t`.

# Examples

```julia
julia> X = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> arraymwe(X)
X = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix
```
"""
function arraymwe(t::AbstractMatrix; returnstring=false, name=:X)
    main_io = IOBuffer()
    array_io = IOBuffer()

    start_str = """
$name = \"\"\"
"""
    print(main_io, start_str)

    CSV.write(array_io, Tables.table(t); header=false)
    print(main_io, String(take!(array_io)))

    end_str = """
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix"""
    print(main_io, end_str)
    s = String(take!(main_io))
    println(s)

    if returnstring == true
      return s
    else
      return nothing
    end
end

"""
    arraymwe(t::AbstractVector; name=:x)

Create a Minimum Working Example (MWE) from
a `Vector`. `arraymwe`
returns the a multi-line string with the
code necessary to recreate `t`.

# Example

```julia
julia> arraymwe(x; name=:x)
x = \"\"\"
1
2
3
4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix |> vec
```
"""
function arraymwe(t::AbstractVector; returnstring=false, name=:x)
    main_io = IOBuffer()
    array_io = IOBuffer()

    t = reshape(t, :, 1)

    start_str = """
$name = \"\"\"
"""
    print(main_io, start_str)

    CSV.write(array_io, Tables.table(t); header=false)
    print(main_io, String(take!(array_io)))

    end_str = """
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix |> vec"""
    print(main_io, end_str)
    s = String(take!(main_io))
    println(s)

    if returnstring == true
      return s
    else
      return nothing
    end
end

function arraymwe_helper(t::Symbol)
    t_name = QuoteNode(t)
    :(arraymwe($t, name=$t_name))
end

"""
    arraymwe(t)

Create a Minimum Working Example (MWE)
from a `Vector` or `Matrix` with the same
name as the object in the Julia session.

# Examples

```julia
julia> my_special_matrix = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> @arraymwe my_special_matrix
my_special_matrix = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix
```
"""
macro arraymwe(t)
    esc(arraymwe_helper(t))
end

end
