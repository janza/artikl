defmodule Artikl.Router do
  use Artikl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Artikl do
    pipe_through :browser # Use the default browser stack

    # get "/", PageController, :index
    resources "/", ArticleController
  end


  # Other scopes may use custom stacks.
  scope "/api", Artikl do
    pipe_through :api

    resources "/articles", ArticleController
  end
end
