# ClipData.jl

Copy/paste to/from Excel, Google Sheets, and other tabular data sources into interactive Julia sessions.

Interactive Julia sessions include the REPL, Pluto notebooks, Jupyter notebooks, and more!


ClipData uses [CSV.jl](https://csv.juliadata.org/stable/) under the hood for fast and flexible parsing of tabular data on the clipboard. 

## `cliptable` for data with headers

- `cliptable()` will copy data from the clipboard into a `CSV.File`. Pass to a `DataFrame` to create a dataframe object.
- `cliptable(data)` will copy the Julia variable `data` to the clipboard

```@raw html
<video controls width="680">
<source src="https://user-images.githubusercontent.com/711879/116339390-f44a9080-a7a2-11eb-9e3b-9d4716747bd1.mp4"
            type="video/mp4">
</video>
```



## `cliparray` for matrix or vector data

- `cliparray()` will copy data from the clipboard into a Julia array.
- `cliparray(data)` will copy the Julia variable `data` to the clipboard

```@raw html
<video controls width="680">
<source src="https://user-images.githubusercontent.com/711879/116340294-8c954500-a7a4-11eb-9159-cc9dc3fda80a.mp4"
            type="video/mp4">
</video>
```


## Keyword arguments

Keyword arguments passed to `cliptable` or `cliparray` will be passed to CSV.jl, so you can customize the behavior of the data "pasted" to Julia. See the [CSV.jl docs](https://csv.juliadata.org/stable/) for more info.

### Example

This will remove whitespace and standardize headers for tabular data:

```julia
cliptable(;normalizenames=true)
```

## `tablemwe` and `arraymwe` for creating Minimum Working Examples (MWEs)

ClipData also makes it easy to take data from a the clipboard or a Julia session and enter it directly int a script with the functions `tablemwe` and `arraymwe`, as well as the corresponding macros `@tablemwe` and `@arraymwe`.

### Example

Say you have an existing data frame with the population of cities on the West Coast of the USA, and you want to share this data with someone without sending an Excel file. `tablemwe` allows you to create reproducible code on the fly. 

```julia
julia> west_coast_cities
5×2 DataFrame
 Row │ City           Population 
     │ String         Int64      
─────┼───────────────────────────
   1 │ Portland           645291
   2 │ Seattle            724305
   3 │ San Francisco      874961
   4 │ Los Angeles       3967000
   5 │ San Diego         1410000

julia> @tablemwe west_coast_cities
west_coast_cities = """
City,Population
Portland,645291
Seattle,724305
San Francisco,874961
Los Angeles,3967000
San Diego,1410000
""" |> IOBuffer |> CSV.File
```

!!! note 

    `tablemwe` always returns a `CSV.File` object, but this can be easily converted into whatever table type you are working with.