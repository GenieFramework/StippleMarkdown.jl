module StippleMarkdown

using Stipple

export markdowntext, markdowncard

assets_config = Genie.Assets.AssetsConfig(package = "StippleMarkdown.jl")

const deps_routes = String[]
deps() = deps_routes

import Stipple.Genie.Renderer.Html: register_normal_element, normal_element

register_normal_element("markdown__text", context = @__MODULE__)
register_normal_element("markdown__card", context = @__MODULE__)

function markdowntext(text::Symbol)
    markdown__text(;(var":text"=text))
end

function markdowntext(text::String)
    markdown__text(text)
end

function markdowncard(text::Symbol)
    markdown__card(;(var":text"=text))
end

function markdowncard(text::String)
    markdown__card(text)
end

function __init__()
    basedir = dirname(pathof(StippleMarkdown)) |> dirname #go up one level
    for js in ["markdowntext.js", "markdowncard.js", "mdblock.umd.js"]
        s = script(src = Genie.Assets.add_fileroute(assets_config, js; basedir).path)
        push!(deps_routes, s)
    end
end

end
