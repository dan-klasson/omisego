defmodule GithubOmgWeb.JSONConverter do

  @moduledoc """
  A module that converts JSON data to nested JSON data.

  ## Examples

  Takes JSON input like this:

  {
    "0": [
      {
        "id": 1,
        "title": "Foo",
        "children": [],
        "parent_id": null
      }
    ],
    "1": [
      {
        "id": 2,
        "title": "Bar",
        "children": [],
        "parent_id": 1
      },
      {
        "id": 2,
        "title": "Baz",
        "children": [],
        "parent_id": 1
      }
  }
  And converts it like this:

  [
      {
          "id": 10,
          "level": 0,
          "parent_id": null,
          "title": "Foo",
          "children": [ // Bar & Baz go here ]
      }
  ]

  """

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

