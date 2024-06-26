using GenieFramework
@genietools
using StippleMarkdown

@app begin
    @out txt = "**hello** world"
end
@deps StippleMarkdown

ui() = [ markdowntext("## Hello World!"), markdowntext(:txt), markdowncard("## Hello World!\n This is a Markdown card"), br(), markdowncard(:txt)]

@page("/", ui)
