defmodule EcophazWeb.UserController do
  use EcophazWeb, :controller

  alias Ecophaz.Accounts
  alias Ecophaz.Accounts.{User}
  alias EcophazWeb.{Mailer, Email}
  alias EcophazWeb.Services.Authenticator

  action_fallback EcophazWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def request_change_password(conn, %{"email" => email}) do
    with %User{id: id, name: name} <- Accounts.get_user_by(email: email) do
      token = Authenticator.generate_token("reset_password:#{id}")
      Email.request_change_password_email(email, name, token) |> Mailer.deliver_now()
      conn |> send_resp(200, "OK")
    end
  end

  def change_password(conn, %{"token" => token, "password" => password}) do
    with {:ok, _token, "reset_password:" <> id} <- Authenticator.verify_token(token),
         %User{} = user <- Accounts.get_user(id),
         {:ok, %User{}} <- user |> Accounts.update_user(%{password: password}) do
      user |> Accounts.delete_tokens_for_user()
      conn |> send_resp(200, "OK")
    else
      _ -> {:error, :not_found}
    end
  end
end
