defmodule GithubOmgWeb.Router do
  use GithubOmgWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :csrf do
    plug :protect_from_forgery # to here
  end

  scope "/", GithubOmgWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", GithubOmgWeb do
    pipe_through :api
    post "/convert", ConvertController, :convert
  end
end
