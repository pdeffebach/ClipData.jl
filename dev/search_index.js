var documenterSearchIndex = {"docs":
[{"location":"#ClipData.jl","page":"Introduction","title":"ClipData.jl","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Copy/paste to/from Excel, Google Sheets, and other tabular data sources into interactive Julia sessions.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Interactive Julia sessions include the REPL, Pluto notebooks, Jupyter notebooks, and more!","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"ClipData uses CSV.jl under the hood for fast and flexible parsing of tabular data on the clipboard. ","category":"page"},{"location":"#cliptable-for-data-with-headers","page":"Introduction","title":"cliptable for data with headers","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"cliptable() will copy data from the clipboard into a CSV.File. Pass to a DataFrame to create a dataframe object.\ncliptable(data) will copy the Julia variable data to the clipboard","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"<video controls width=\"680\">\n<source src=\"https://user-images.githubusercontent.com/711879/116339390-f44a9080-a7a2-11eb-9e3b-9d4716747bd1.mp4\"\n            type=\"video/mp4\">\n</video>","category":"page"},{"location":"#cliparray-for-matrix-or-vector-data","page":"Introduction","title":"cliparray for matrix or vector data","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"cliparray() will copy data from the clipboard into a Julia array.\ncliparray(data) will copy the Julia variable data to the clipboard","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"<video controls width=\"680\">\n<source src=\"https://user-images.githubusercontent.com/711879/116340294-8c954500-a7a4-11eb-9159-cc9dc3fda80a.mp4\"\n            type=\"video/mp4\">\n</video>","category":"page"},{"location":"#Keyword-arguments","page":"Introduction","title":"Keyword arguments","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Keyword arguments passed to cliptable or cliparray will be passed to CSV.jl, so you can customize the behavior of the data \"pasted\" to Julia. See the CSV.jl docs for more info.","category":"page"},{"location":"#Example","page":"Introduction","title":"Example","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"This will remove whitespace and standardize headers for tabular data:","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"cliptable(;normalizenames=true)","category":"page"},{"location":"#mwetable-and-mwearray-for-creating-Minimum-Working-Examples-(MWEs)","page":"Introduction","title":"mwetable and mwearray for creating Minimum Working Examples (MWEs)","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"ClipData also makes it easy to take data from a the clipboard or a Julia session and enter it directly int a script with the functions mwetable and mwearray, as well as the corresponding macros @mwetable and @mwearray.","category":"page"},{"location":"#Example-2","page":"Introduction","title":"Example","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Say you have an existing data frame with the population of cities on the West Coast of the USA, and you want to share this data with someone without sending an Excel file. mwetable allows you to create reproducible code on the fly. ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> west_coast_cities\n5×2 DataFrame\n Row │ City           Population \n     │ String         Int64      \n─────┼───────────────────────────\n   1 │ Portland           645291\n   2 │ Seattle            724305\n   3 │ San Francisco      874961\n   4 │ Los Angeles       3967000\n   5 │ San Diego         1410000\n\njulia> @mwetable west_coast_cities\nwest_coast_cities = \"\"\"\nCity,Population\nPortland,645291\nSeattle,724305\nSan Francisco,874961\nLos Angeles,3967000\nSan Diego,1410000\n\"\"\" |> IOBuffer |> CSV.File","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"note: Note\nmwetable always returns a CSV.File object, but this can be easily converted into whatever table type you are working with.","category":"page"},{"location":"api/api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/api/","page":"API","title":"API","text":"cliptable","category":"page"},{"location":"api/api/#ClipData.cliptable","page":"API","title":"ClipData.cliptable","text":"cliptable(; kwargs...)\n\nMake a table from the clipboard. Returns a CSV.File, which can then be transformed into a DataFrame or other Tables.jl-compatible object.\n\ncliptable auto-detects delimiters, and all keyword arguments are passed directly to the CSV.File constructor.\n\nExamples\n\njulia> # Send string to the clipboard\n       \"\"\"\n       a, b\n       1, 2\n       100, 200\n       \"\"\" |> clipboard\n\njulia> cliptable()\n2-element CSV.File{false}:\n CSV.Row: (a = 1,  b = 2)\n CSV.Row: (a = 100,  b = 200)\n\n\n\n\n\ncliptable(t; delim = '\t', kwargs...)\n\nSend a Tables.jl-compatible object to the clipboard. Default delimiter is tab. Accepts all keyword arguments that can be pased to CSV.write.\n\nExample\n\njulia> t = (a = [1, 2, 3], b = [100, 200, 300])\n(a = [1, 2, 3], b = [100, 200, 300])\n\njulia> cliptable(t)\na   b\n1   100\n2   200\n3   300\n\n\n\n\n\n","category":"function"},{"location":"api/api/","page":"API","title":"API","text":"cliparray","category":"page"},{"location":"api/api/#ClipData.cliparray","page":"API","title":"ClipData.cliparray","text":"cliparray(; kwargs...)\n\nMake a Vector or Matrix from the clipboard. Auto-detects delimiters, and all keyword arguments are passed directly to a CSV.File constructor. If the returned CSV.File has one column, cliparray returns a Vector. Otherwise, it returns a Matrix.\n\nExamples\n\njulia> # Send string to clipboard\n       \"\"\"\n       1 2\n       3 4\n       \"\"\" |> clipboard\n\njulia> cliparray()\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\njulia> \"\"\"\n       1\n       2\n       3\n       4\n       \"\"\" |> clipboard\n\njulia> cliparray()\n4-element Vector{Int64}:\n 1\n 2\n 3\n 4\n\n\n\n\n\ncliparray(t::AbstractVecOrMat; kwargs...)\n\nSend a Vector or Matrix to the clipboard. Default delimiter is tab and with no header. Accepts all keyword arguments that can be passed to CSV.write.\n\nExamples\n\njulia> \"\"\"\n       1 2\n       3 4\n       \"\"\" |> clipboard\n\njulia> cliparray()\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\n\n\n\n\n","category":"function"},{"location":"api/api/","page":"API","title":"API","text":"mwetable","category":"page"},{"location":"api/api/#ClipData.mwetable","page":"API","title":"ClipData.mwetable","text":"mwetable([io::IO=stdout]; name=\"df\")\n\nCreate a Minimum Working Example (MWE) using the clipboard. tablmwe prints out a multi-line comma-separated string and provides the necessary code to read that string using CSV.File. The object is assigned the name given by name (default \"df\"). Prints to io, which is by default stdout.\n\nExamples\n\njulia> \"\"\"\n       a b\n       1 2\n       100 200\n       \"\"\" |> clipboard\n\njulia> mwetable()\ndf = \"\"\"\na,b\n1,2\n100,200\n\"\"\" |> IOBuffer |> CSV.File\n\n\n\n\n\nmwetable([io::IO=stdout], t; name=\"df\")\n\nCreate a Minimum Working Example (MWE) from an existing Tables.jl-compatible object. tablmwe prints out a multi-line comma-separated string and provides the necessary code to read that string using CSV.File. The object is assigned the name given by name (default :df). Prints to io, which is by default stdout.\n\nExamples\n\njulia> t = (a = [1, 2, 3], b = [100, 200, 300])\n(a = [1, 2, 3], b = [100, 200, 300])\n\njulia> mwetable(t)\ndf = \"\"\"\na,b\n1,100\n2,200\n3,300\n\"\"\" |> IOBuffer |> CSV.File\n\n\n\n\n\n","category":"function"},{"location":"api/api/","page":"API","title":"API","text":"mwearray","category":"page"},{"location":"api/api/#ClipData.mwearray","page":"API","title":"ClipData.mwearray","text":"mwearray([io::IO=stdout]; name=:X)\n\nCreate a Minimum Working Example (MWE) from the clipboard to create an array. mwearray returns the a multi-line string with the code necessary to read the string stored in clipboard as a Vector or Matrix. Prints to io, which is by default stdout.\n\nExamples\n\njulia> \"\"\"\n       1 2\n       3 4\n       \"\"\" |> clipboard\n\njulia> mwearray()\nX = \"\"\"\n1,2\n3,4\n\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix\n\n\n\n\n\nmwearray([io::IO=stdout], t::AbstractMatrix; name=:X)\n\nCreate a Minimum Working Example (MWE) from a Matrix. mwearray returns the a multi-line string with the code necessary to recreate t. Prints to io, which is by default stdout.\n\nExamples\n\njulia> X = [1 2; 3 4]\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\njulia> mwearray(X)\nX = \"\"\"\n1,2\n3,4\n\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix\n\n\n\n\n\nmwearray([io::IO=stdout], t::AbstractVector; name=:x)\n\nCreate a Minimum Working Example (MWE) from a Vector. mwearray returns the a multi-line string with the code necessary to recreate t. Prints to io, which is by default stdout.\n\nExample\n\njulia> mwearray(x; name=:x)\nx = \"\"\"\n1\n2\n3\n4\n\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix |> vec\n\n\n\n\n\n","category":"function"},{"location":"api/api/","page":"API","title":"API","text":"@mwetable","category":"page"},{"location":"api/api/#ClipData.@mwetable","page":"API","title":"ClipData.@mwetable","text":"@mwetable(t)\n\nCreate a Minimum Working Example (MWE) from an existing Tables.jl-compatible object. tablmwe prints out a multi-line comma-separated string and provides the necessary code to read that string using CSV.File. The name assigned to the object in the MWE is the same as the name of the input object. Prints to stdout.\n\nExamples\n\njulia> my_special_table = (a = [1, 2, 3], b = [100, 200, 300])\n(a = [1, 2, 3], b = [100, 200, 300])\n\njulia> @mwetable my_special_table\nmy_special_table = \"\"\"\na,b\n1,100\n2,200\n3,300\n\"\"\" |> IOBuffer |> CSV.File\n\n\n\n\n\n","category":"macro"},{"location":"api/api/","page":"API","title":"API","text":"@mwearray","category":"page"},{"location":"api/api/#ClipData.@mwearray","page":"API","title":"ClipData.@mwearray","text":"@mwearray(t)\n\nCreate a Minimum Working Example (MWE) from a Vector or Matrix with the same name as the object in the Julia session. Prints to stdout.\n\nExamples\n\njulia> my_special_matrix = [1 2; 3 4]\n2×2 Matrix{Int64}:\n 1  2\n 3  4\n\njulia> @mwearray my_special_matrix\nmy_special_matrix = \"\"\"\n1,2\n3,4\n\"\"\" |> IOBuffer |> CSV.File |> Tables.matrix\n\n\n\n\n\n","category":"macro"}]
}
