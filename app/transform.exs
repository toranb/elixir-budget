{:ok, assets} = File.read("priv/static/asset-manifest.json")
map = Poison.Parser.parse!(assets, %{})

css_filename = "lib/example_web/templates/layout/app.html.eex"
{:ok, layout} = File.read(css_filename)

css = Regex.replace(~r/main\.css/, layout, fn (word, _) ->
  string = Map.get(map, word)
  Regex.replace(~r/^\/static\/css\/(.*)/, string, "\\1")
end)

File.write(css_filename, css)

js_filename = "lib/example_web/templates/budget/index.html.eex"
{:ok, budget} = File.read(js_filename)

js = Regex.replace(~r/main\.js/, budget, fn (word, _) ->
  string = Map.get(map, word)
  Regex.replace(~r/^\/static\/js\/(.*)/, string, "\\1")
end)

File.write(js_filename, js)
