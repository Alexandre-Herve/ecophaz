defmodule Ecophaz.Accounts do
  alias Ecophaz.Services.Authenticator
  alias Ecophaz.Repo
  alias Ecophaz.Accounts.{AuthToken, User}

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user)

        user
        |> Ecto.build_assoc(:auth_tokens, %{token: token})
        |> Repo.insert()

      err ->
        err
    end
  end

  def sign_out(token) do
    case Authenticator.verify_token(token) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end

      _error ->
        {:error, :invalid_auth_header}
    end
  end

  def get_token(token) do
    with {:ok, token} <- Authenticator.verify_token(token),
         auth_token <-
           AuthToken
           |> Ecophaz.Repo.get_by(%{token: token, revoked: false})
           |> Repo.preload(:user) do
      auth_token
    else
      _ -> nil
    end
  end
end
