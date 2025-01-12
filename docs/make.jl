using ChairmarksForAirspeedVelocity
using Documenter

DocMeta.setdocmeta!(ChairmarksForAirspeedVelocity, :DocTestSetup, :(using ChairmarksForAirspeedVelocity); recursive=true)

makedocs(;
    modules=[ChairmarksForAirspeedVelocity],
    authors="Lilith Orion Hafner <lilithhafner@gmail.com> and contributors",
    sitename="ChairmarksForAirspeedVelocity.jl",
    format=Documenter.HTML(;
        canonical="https://LilithHafner.github.io/ChairmarksForAirspeedVelocity.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/LilithHafner/ChairmarksForAirspeedVelocity.jl",
    devbranch="main",
)
