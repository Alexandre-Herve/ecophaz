defmodule EcophazWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use EcophazWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(EcophazWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(EcophazWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(EcophazWeb.ErrorView)
    |> render(:"403")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(EcophazWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, _reason}) do
    conn
    |> put_status(:bad_request)
    |> put_view(EcophazWeb.ErrorView)
    |> render(:"400")
  end

  def call(conn, _error) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(EcophazWeb.ErrorView)
    |> render(:"500")
  end
end
