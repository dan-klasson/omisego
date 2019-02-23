defmodule GithubOmgWeb.Router do
  use GithubOmgWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GithubOmgWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:page", PageController, :index
  end

  scope "/api", GithubOmgWeb do
    pipe_through :api
    post "/convert", ConvertController, :convert
  end
end
