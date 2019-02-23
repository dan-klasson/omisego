defmodule GithubOmgWeb.PageController do
  use GithubOmgWeb, :controller
  alias GithubOmgWeb.Paginator

  @per_page 10
  @max_display 10
  @max_results 1000

  def index(conn, params) do

    page = Map.get(params, "page", "1")
      |> String.to_integer

    repos = Github.search_repositories("elixir", page, @per_page)

    paginator = %Paginator{
      page: page,
      per_page: @per_page,
      max_display: @max_display,
      max_results: @max_results,
      total: repos["total_count"]
    }
      |> Paginator.call

    render(conn, "index.html", repos: repos, paginator: paginator)
  end

end
