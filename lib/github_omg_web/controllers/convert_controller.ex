alias GithubOmgWeb.JSONConverter, as: JSONConverter

defmodule GithubOmgWeb.ConvertController do
  use GithubOmgWeb, :controller

  def convert(conn, params) do
    response = JSONConverter.action(params)
    json(conn, response)
  end

end
