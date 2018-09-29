defmodule EcophazWeb.Router do
  use EcophazWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EcophazWeb do
    pipe_through :api
  end
end
