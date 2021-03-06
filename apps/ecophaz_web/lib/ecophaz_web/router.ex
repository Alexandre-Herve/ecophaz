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

    post "/users/create", UserController, :create
    post "/users/request_change_password", UserController, :request_change_password
    post "/users/change_password", UserController, :change_password
  end

  scope "/api/v1/", EcophazWeb do
    pipe_through :private_api

    resources "/moods", MoodController, except: [:new, :edit]
    post "/moods/:id/like", MoodController, :like
    delete "/moods/:id/unlike", MoodController, :unlike
    resources "/users", UserController, only: [:show]
  end
end
