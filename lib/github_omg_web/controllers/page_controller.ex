defmodule GithubOmgWeb.PageController do
  use GithubOmgWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
