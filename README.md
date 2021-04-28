# ClipData.jl

Copy/paste to/from Excel, Google Sheets, and other tabular data sources into interactive Julia sessions. 

Interactive Julia sessions include the REPL, Pluto notebooks, Jupyter notebooks, and more!

ClipData uses [CSV.jl](https://csv.juliadata.org/stable/) under the hood for fast and flexible parsing of tabular data on the clipboard. 

## `cliptable` for data with headers

- `cliptable()` will copy data from the clipboard into a `CSV.File`. Pass to a `DataFrame` to create a dataframe object.
- `cliptable(data)` will copy the Julia variable `data` to the clipboard


https://user-images.githubusercontent.com/711879/116339390-f44a9080-a7a2-11eb-9e3b-9d4716747bd1.mp4


## `cliptable` for matrix or vector data

- `cliptable()` will copy data from the clipboard into a Julia array.
- `cliptable(data)` will copy the Julia variable `data` to the clipboard


https://user-images.githubusercontent.com/711879/116340294-8c954500-a7a4-11eb-9159-cc9dc3fda80a.mp4


## Keyword arguments

Keyword arguments passed to `cliptable` or `cliparray` will be passed to CSV.jl, so you can customize the behavior of the data "pasted" to Julia. See the [CSV.jl docs]([CSV.jl](https://csv.juliadata.org/stable/) for more info.

### Example

This will remove whitespace and standardize headers for tabular data:

```julia
cliptable(;normalizenames=true)
```
