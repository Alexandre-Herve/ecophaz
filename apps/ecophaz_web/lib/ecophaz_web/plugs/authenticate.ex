defmodule EcophazWeb.Plugs.Authenticate do
  import Plug.Conn
  def init(default), do: default
  alias EcophazWeb.Services.Authenticator
  alias Ecophaz.Accounts

  def call(conn, _default) do
    with {:ok, token} <- Authenticator.extract_token(conn),
         token when not is_nil(token) <- Accounts.get_token(token) do
      authorized(conn, token.user)
    else
      _ -> unauthorized(conn)
    end
  end

  defp authorized(conn, user) do
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
