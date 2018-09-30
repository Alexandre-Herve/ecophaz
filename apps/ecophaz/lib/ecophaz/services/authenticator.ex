defmodule Ecophaz.Services.Authenticator do
  def generate_token(id) do
    auth_config = Application.get_env(:ecophaz, :auth)

    Phoenix.Token.sign(
      auth_config |> Keyword.get(:secret),
      auth_config |> Keyword.get(:seed),
      id,
      max_age: 86400
    )
  end

  def verify_token(token) do
    auth_config = Application.get_env(:ecophaz, :auth)

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
end
