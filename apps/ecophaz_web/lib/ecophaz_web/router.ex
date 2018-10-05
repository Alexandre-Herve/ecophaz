defmodule EcophazWeb.Router do
  use EcophazWeb, :router

  pipeline :public_api do
    plug :accepts, ["json"]
  end

  pipeline :private_api do
    plug :accepts, ["json"]
    plug EcophazWeb.Plugs.Authenticate
  end

  scope "/api/v1", EcophazWeb do
    pipe_through :public_api
    post "/sessions/sign_in", SessionsController, :create
    delete "/sessions/sign_out", SessionsController, :delete
  end

  scope "/api/v1/", EcophazWeb do
    pipe_through :private_api
    resources "/moods", MoodController, except: [:new, :edit]
  end
end
