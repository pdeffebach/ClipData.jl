module ClipData

using CSV, Tables

using InteractiveUtils: clipboard

export cliptable, cliparray, mwetable, mwearray, @mwetable, @mwearray

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

```julia-repl
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

```julia-repl
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
```
"""
function cliparray(; kwargs...)
    t = CSV.File(IOBuffer(clipboard()); header=false, kwargs...)
    mat = Tables.matrix(t)
    if size(mat, 2) == 1 || size(mat, 1) == 1
        return vec(mat)
    else
        return mat
    end
end

"""
    cliptable(t; delim = '\t', kwargs...)

Send a Tables.jl-compatible object to the clipboard.
Default delimiter is tab. Accepts all keyword arguments
that can be pased to `CSV.write`.

# Example

```julia-repl
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

```julia-repl
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

    if returnstring == true
      return s
    else
      return nothing
    end
end

"""
    mwetable(; name="df")

Create a Minimum Working Example (MWE) using
the clipboard. `tablmwe` prints out a multi-line
comma-separated string and provides the necessary
code to read that string using `CSV.File`.
The object is assigned the name given by
`name` (default `"df"`).

# Examples

```julia-repl
julia> \"\"\"
       a b
       1 2
       100 200
       \"\"\" |> clipboard

julia> mwetable()
df = \"\"\"
a,b
1,2
100,200
\"\"\" |> IOBuffer |> CSV.File
```

"""
function mwetable(; returnstring=false, name="df")
    t = cliptable()
    mwetable(t, returnstring=returnstring, name=name)
end

"""
    mwetable([io::IO=stdout], t; name="df")

Create a Minimum Working Example (MWE) from
an existing Tables.jl-compatible object.
`tablmwe` prints out a multi-line
comma-separated string and provides the necessary
code to read that string using `CSV.File`.
The object is assigned the name given by
`name` (default `:df`).

# Examples

```julia-repl
julia> t = (a = [1, 2, 3], b = [100, 200, 300])
(a = [1, 2, 3], b = [100, 200, 300])

julia> mwetable(t)
df = \"\"\"
a,b
1,100
2,200
3,300
\"\"\" |> IOBuffer |> CSV.File
```
"""
function mwetable(io::IO, t; returnstring=false, name="df")
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

    if returnstring == true
      return s
    else
      print(io, s)
      return nothing
    end
end

mwetable(t; kwargs...) = mwetable(stdout, t; kwargs...)

function mwetable_helper(t::Symbol)
    t_name = QuoteNode(t)
    :(mwetable($t, name = $t_name))
end

"""
    @mwetable(t)

Create a Minimum Working Example (MWE) from
an existing Tables.jl-compatible object.
`tablmwe` prints out a multi-line
comma-separated string and provides the necessary
code to read that string using `CSV.File`. The name
assigned to the object in the MWE is the
same as the name of the input object.

# Examples

```julia-repl
julia> my_special_table = (a = [1, 2, 3], b = [100, 200, 300])
(a = [1, 2, 3], b = [100, 200, 300])

julia> @mwetable my_special_table
my_special_table = \"\"\"
a,b
1,100
2,200
3,300
\"\"\" |> IOBuffer |> CSV.File
```
"""
macro mwetable(t)
    esc(mwetable_helper(t))
end

"""
    mwearray(; name=:X)

Create a Minimum Working Example (MWE) from
the clipboard to create an array. `mwearray`
returns the a multi-line string with the
code necessary to read the string stored in
clipboard as a `Vector` or `Matrix`.

# Examples

```julia-repl
julia> \"\"\"
       1 2
       3 4
       \"\"\" |> clipboard

julia> mwearray()
X = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix
```
"""
function mwearray(; returnstring=false, name=nothing)
    t = cliparray()
    name= t isa AbstractVector ? :x : :X
    mwearray(t, returnstring=returnstring, name=name)
end

"""
    mwearray([io::IO=stdout], t::AbstractMatrix; name=:X)

Create a Minimum Working Example (MWE) from
a `Matrix`. `mwearray`
returns the a multi-line string with the
code necessary to recreate `t`.

# Examples

```julia-repl
julia> X = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> mwearray(X)
X = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix
```
"""
function mwearray(io::IO, t::AbstractMatrix; returnstring=false, name=:X)
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

    if returnstring == true
      return s
    else
      print(io, s)
      return nothing
    end
end

"""
    mwearray([io::IO=stdout], t::AbstractVector; name=:x)

Create a Minimum Working Example (MWE) from
a `Vector`. `mwearray`
returns the a multi-line string with the
code necessary to recreate `t`.

# Example

```julia-repl
julia> mwearray(x; name=:x)
x = \"\"\"
1
2
3
4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix |> vec
```
"""
function mwearray(io::IO, t::AbstractVector; returnstring=false, name=:x)
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

    if returnstring == true
      return s
    else
      print(io, s)
      return nothing
    end
end

mwearray(t::Union{AbstractVector, AbstractMatrix}; kwargs...) = mwearray(stdout, t; kwargs...)

function mwearray_helper(t::Symbol)
    t_name = QuoteNode(t)
    :(mwearray($t, name=$t_name))
end

"""
    @mwearray(t)

Create a Minimum Working Example (MWE)
from a `Vector` or `Matrix` with the same
name as the object in the Julia session.

# Examples

```julia-repl
julia> my_special_matrix = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> @mwearray my_special_matrix
my_special_matrix = \"\"\"
1,2
3,4
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix
```
"""
macro mwearray(t)
    esc(mwearray_helper(t))
end

end
