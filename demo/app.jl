using GenieFramework
@genietools
using StippleMarkdown

@app begin
    @out txt = "**hello** world"
end
@deps StippleMarkdown

ui() = [ markdowntext(:txt), markdowntext("## Hello World!"), markdowncard(:txt), markdowncard("## Hello World!\n This is a Markdown card")]

@page("/", ui)
