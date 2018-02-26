defmodule AppWeb.Router do
  use AppWeb, :router

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

  scope "/", AppWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/event", AppWeb do
    pipe_through :api

    post "/new", EventController, :new
  end

# Code is the wrong color and is erroring, not sure why. Tried putting this
# inside the existing scope for '/' but it still didn't work
# Code from JC tutorial
  scope “/”, AppWeb do
   pipe_through :browser
   resources “/upload”, UploadController, only: [:create, :new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end
end
