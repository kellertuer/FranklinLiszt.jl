using FranklinLiszt, YAML, Documenter
makedocs(
    format = Documenter.HTML(prettyurls = false),
    modules = [FranklinLiszt],
    authors = "Ronny Bergmann",
    sitename = "FranklinLiszt.jl",
    pages = [
        "Home" => "index.md",
    ],
)
deploydocs(repo = "github.com/kellertuer/FranklinLiszt.jl.git", push_preview = true)
