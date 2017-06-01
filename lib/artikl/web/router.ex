defmodule Artikl.Web.Router do
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

  scope "/api", Artikl.Web do
    pipe_through :api

    resources "/", EntryJSONController
  end

  scope "/", Artikl.Web do
    pipe_through :browser

    resources "/", EntryController
  end
end
