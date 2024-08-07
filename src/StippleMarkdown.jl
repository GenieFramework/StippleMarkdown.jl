module StippleMarkdown

using Stipple, StippleUI.API

export markdowntext, markdowncard

const assets_config = Genie.Assets.AssetsConfig(package="StippleMarkdown.jl")

import Stipple.Genie.Renderer.Html: register_normal_element, normal_element

register_normal_element("markdown__text", context=@__MODULE__)
register_normal_element("markdown__card", context=@__MODULE__)

function markdowntext(text::Symbol)
    markdown__text(; kw([:text => text])...)
end

function markdowntext(text::String)
    markdown__text(text)
end

function markdowncard(text::Symbol, title::Union{Symbol,String}="")
    markdown__card(; kw([:text => text, :title => title])...)
end

function markdowncard(text::String, title::Union{Symbol,String}="")
    markdown__card(text; kw([:title => title])...)
end

function deps_routes()
    Genie.Assets.external_assets(Stipple.assets_config) && return nothing

    Genie.Router.route(Genie.Assets.asset_route(assets_config, :js, file="markdowntext"), named=:get_markdowntextjs) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")), file="markdowntext.js")),
            :javascript) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(assets_config, :js, file="markdowncard"), named=:get_markdowncardjs) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")), file="markdowncard.js")),
            :javascript) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(assets_config, :js, file="mdblock.umd"), named=:get_mdblockumdjs) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")), file="mdblock.umd.js")),
            :javascript) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(assets_config, :json, file="definitions"), named=:get_definitionsjson) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")), file="definitions.json")),
            :json) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(assets_config, :css, file="canvas"), named=:get_canvascss) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")), file="canvas.css")),
            :css) |> Genie.Renderer.respond
    end

    nothing
end

function deps()
    [
        Genie.Renderer.Html.script(src=Genie.Assets.asset_path(assets_config, :js, file="markdowntext")),
        Genie.Renderer.Html.script(src=Genie.Assets.asset_path(assets_config, :js, file="markdowncard")),
        Genie.Renderer.Html.script(src=Genie.Assets.asset_path(assets_config, :js, file="mdblock.umd"))
    ]
end

function __init__()
    deps_routes()
    Stipple.deps!(@__MODULE__, deps)
end

end
