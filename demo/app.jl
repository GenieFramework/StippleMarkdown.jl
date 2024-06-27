using GenieFramework
@genietools
using StippleMarkdown

@app begin
    @out txt = "**hello** world"
    @out title = "Markdown card"
end
@deps StippleMarkdown

ui() = [ markdowntext("## Hello World!"), markdowntext(:txt), markdowncard("Hello **world**", "Markdown card"), br(), markdowncard(:txt, :title), br(), markdowncard(:txt)]

@page("/", ui)
