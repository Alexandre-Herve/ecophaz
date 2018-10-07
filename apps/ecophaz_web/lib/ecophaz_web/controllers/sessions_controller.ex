defmodule EcophazWeb.SessionsController do
  use EcophazWeb, :controller

  alias EcophazWeb.Services.Authenticator

  action_fallback EcophazWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, auth_token} <- Authenticator.sign_in(email, password) do
      conn
      |> put_status(:ok)
      |> render("show.json", auth_token)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def delete(conn, _) do
    with {:ok, _} <- Authenticator.sign_out(conn) do
      conn |> send_resp(204, "")
    else
      {:error, :missing_auth_header} -> {:error, :bad_request}
      {:error, :invalid_auth_header} -> {:error, :forbidden}
    end
  end
end
