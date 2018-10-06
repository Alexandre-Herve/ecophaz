defmodule EcophazWeb.Services.Authenticator do
  alias Ecophaz.Accounts
  alias Ecophaz.Accounts.User

  def sign_in(email, password) do
    with user = %User{} <- Accounts.get_user_by(email: email),
         {:ok, user} <- Comeonin.Bcrypt.check_pass(user, password) do
      token = generate_token(user)
      Accounts.create_token_for_user(user, %{token: token})
    else
      err -> err
    end
  end

  def sign_out(conn) do
    with {:ok, token} <- get_token(conn),
         auth_token when not is_nil(auth_token) <- Accounts.get_token_by(%{token: token}) do
      Accounts.delete_token(auth_token)
    else
      _ -> {:error, :invalid_auth_header}
    end
  end

  def generate_token(id) do
    auth_config = Application.get_env(:ecophaz_web, :auth)

    Phoenix.Token.sign(
      auth_config |> Keyword.get(:secret),
      auth_config |> Keyword.get(:seed),
      id,
      max_age: 86400
    )
  end

  def verify_token(token) do
    auth_config = Application.get_env(:ecophaz_web, :auth)

    case Phoenix.Token.verify(
           auth_config |> Keyword.get(:secret),
           auth_config |> Keyword.get(:seed),
           token,
           max_age: 86400
         ) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end

  def get_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
      _ -> {:error, :missing_auth_header}
    end
  end

  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")

    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> {:error, "token not found"}
    end
  end
end
