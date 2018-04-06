defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AppWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :gh_oauth do
    plug AppWeb.Plugs.GHOAuth
  end

  scope "/", AppWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", AppWeb do
    pipe_through [:browser, :gh_oauth]

    get "/issues/:id", IssueController, :show
    get "/comments/:id", CommentController, :show
  end

  scope "/auth", AppWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
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
