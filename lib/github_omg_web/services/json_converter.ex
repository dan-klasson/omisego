defmodule GithubOmgWeb.JSONConverter do

  def action(body) do
    body
      |> flatten
      |> convert([], nil)
  end

  defp flatten(content) do
    Enum.reduce(content, [], fn {_, maps}, acc -> acc ++ maps end)
  end

  defp convert(source, target, n) do
    data = Enum.filter(source, fn val -> val["parent_id"] == n end)
    if length(data) > 0 do
      target ++ Enum.map(data, fn(x) ->
        Map.put(x, "children", convert(source, [], x["id"]))
      end)
    else
      target
    end
  end

end

