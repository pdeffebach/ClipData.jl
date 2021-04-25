module ClipData

using CSV, Tables

using InteractiveUtils: clipboard

export cliptable, cliparray, tablemwe, arraymwe

"""
    cliptable(; kwargs...)

Make a table from the clipboard. Returns
a `CSV.File`, which can then be transformed
into a `DataFrame` or other Tables.jl-compatible
object.

`cliptable` auto-detects delimiters, and all keyword arguments are passed
directly to the `CSV.File` constructor.
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
   cliptable(t; delim = '\t', kwargs...)

Send a Tables.jl-compatible object to the clipboard.
Default delimiter is tab. Accepts all keyword arguments
that can be pased to `CSV.write`.
"""
function cliptable(t; delim = '\t', kwargs...)
    io = IOBuffer()
    CSV.write(io, t, delim = delim, kwargs...)
    s = String(take!(io))
    clipboard(s)
    println(s)
    return nothing
end

"""
    cliparray(t::AbstractVecOrMat; kwargs...)

Send a `Vector` or `Matrix` to the clipboard.
Default delimiter is tab and with no header.
Accepts all keyword arguments that can be passed
to `CSV.write`.
"""
function cliparray(t::AbstractVecOrMat; delim='\t', header=false, kwargs...)
    if t isa AbstractVector
        t = reshape(t, :, 1)
    end
    io = IOBuffer()
    CSV.write(io, Tables.table(t); delim=delim, header=header, kwargs...)
    s = String(take!(io))
    clipboard(s)
    println(s)
    return nothing
end

# Clipboard to MWE
function tablemwe(; name="df")
    t = cliptotable()
    tabletomwe(t, name)
end

function tablemwe(t; name="df")
    main_io = IOBuffer()
    table_io = IOBuffer()

    start_str = """
$name = \"\"\"
"""
    print(main_io, start_str)

    CSV.write(table_io, t;)
    print(main_io, String(take!(table_io)))

    end_str = """
\"\"\" |> IOBuffer |> CSV.File
"""
    println(main_io, end_str)
    s = String(take!(main_io))
    println(s)
    clipboard(s)
    return nothing
end

function tablemwe_helper(t::Symbol)
    t = string(t)
    :(tabletomwe($t, $t_name))
end

macro tablemwe(t)
    esc(tabletomwe_helper(t))
end

function arraymwe(; name="X")
    t = cliparray()
    arraymwe(t, name=name)
end

function arraymwe(t::AbstractMatrix; name="X")
    main_io = IOBuffer()
    array_io = IOBuffer()

    start_str = """
$name = \"\"\"
"""
    print(main_io, start_str)

    CSV.write(array_io, Tables.table(t); header=false)
    print(main_io, String(take!(array_io)))

    end_str = """
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix
"""
    println(main_io, end_str)
    s = String(take!(main_io))
    println(s)
    clipboard(s)
    return nothing
end

function arraymwe(t::AbstractVector; name="x")
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
\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix |> vec
"""
    println(main_io, end_str)
    s = String(take!(main_io))
    println(s)
    clipboard(s)
    return nothing
end

function arraymwe_helper(t::Symbol)
    t = string(t)
    :(arraytomwe($t, $t_name))
end

macro arraymwe(t)
    esc(arraytomwe_helper(t))
end

end
