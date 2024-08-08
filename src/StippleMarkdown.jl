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

function gb_component_routes()
    package_subpath_part = "stipplemarkdown" # change these, keep the other parts as defined below

    # don't change these
    # GenieDevTools identifies the components by their asset path, which must be of the form /components/stipplemarkdown/gb_component/
    prefix = "components"
    gb_component_path = "gb_component"
    assets_folder_path = "$package_subpath_part/$gb_component_path"
    icons_folder_path = "icons"

    [
    Genie.Router.route(Genie.Assets.asset_route(
        assets_config,
        "", # type
        file="definitions.json",
        path=assets_folder_path,
        prefix=prefix,
        ext=""
    ),
    named=:get_gb_component_stipplemarkdown_definitionsjson) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(
                Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")),
                file="definitions.json",
                path=gb_component_path,
                type="")
            ),
            :json) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(
        assets_config,
        "", # type
        file="canvas.css",
        path=assets_folder_path,
        prefix=prefix,
        ext=""
    ),
    named=:get_gb_component_stipplemarkdown_canvascss) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(
                Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")),
                file="canvas.css",
                path=gb_component_path,
                type="")
            ),
            :css) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(
        assets_config,
        "", # type
        file="markdowncard.png",
        path="$assets_folder_path/$icons_folder_path",
        prefix=prefix,
        ext=""
    ),
    named=:get_gb_component_stipplemarkdown_icons_markdowncardpng) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(
                Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")),
                file="markdowncard.png",
                path=joinpath(gb_component_path, icons_folder_path),
                type="")
            ),
            :png) |> Genie.Renderer.respond
    end

    Genie.Router.route(Genie.Assets.asset_route(
        assets_config,
        "", # type
        file="markdowntext.png",
        path="$(assets_folder_path)/$icons_folder_path",
        prefix=prefix,
        ext=""
    ),
    named=:get_gb_component_stipplemarkdown_icons_markdowntextpng) do
        Genie.Renderer.WebRenderable(
            Genie.Assets.embedded(
                Genie.Assets.asset_file(cwd=normpath(joinpath(@__DIR__, "..")),
                file="markdowntext.png",
                path=joinpath(gb_component_path, icons_folder_path),
                type="")
            ),
            :png) |> Genie.Renderer.respond
    end
    ]
end

function deps_routes()
    haskey(ENV, "GB_JULIA_PATH") && gb_component_routes()

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
