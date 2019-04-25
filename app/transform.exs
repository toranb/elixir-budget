{:ok, assets} = File.read("priv/static/asset-manifest.json")
map = Poison.Parser.parse!(assets, %{})

css_filename = "lib/example_web/templates/layout/app.html.eex"
{:ok, layout} = File.read(css_filename)

css =
  Regex.replace(~r/main\.css/, layout, fn word, _ ->
    string = Map.get(map, word)
    Regex.replace(~r/^\/static\/css\/(.*)/, string, "\\1")
  end)

File.write(css_filename, css)

js_filename = "lib/example_web/templates/budget/index.html.eex"
{:ok, budget} = File.read(js_filename)

{match, _} = Enum.find(map, fn {k, _} -> String.match?(k, ~r/.*chunk.js/) end)
chunk = Regex.replace(~r/static\/js\/(.*)/, match, "\\1")

js =
  Regex.replace(~r/chunk\.js/, budget, fn _, _ ->
    Regex.replace(~r/(.*)/, chunk, "\\1")
  end)

final =
  Regex.replace(~r/main\.js/, js, fn word, _ ->
    string = Map.get(map, word)
    Regex.replace(~r/^\/static\/js\/(.*)/, string, "\\1")
  end)

File.write(js_filename, final)
