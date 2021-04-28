push!(LOAD_PATH, "../src/")

using Documenter, ClipData

makedocs(
	sitename = "ClipData.jl",
	pages = Any[
		"Introduction" => "index.md",
		"API" => "api/api.md"],
	format = Documenter.HTML(
		canonical = "https://pdeffebach.github.io/ClipData.jl/stable/"
	))

deploydocs(
    repo = "github.com/pdeffebach/ClipData.jl.git",
    target = "build",
    deps = nothing,
    make = nothing)
