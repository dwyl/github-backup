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
    get "/comments/:id", CommentController, :show
  end

  scope "/", AppWeb do
    pipe_through :api

    get "/edit-count/:issue_id", EditCountController, :show
  end

  scope "/event", AppWeb do
    pipe_through :api

    post "/new", EventController, :new
  end

end
