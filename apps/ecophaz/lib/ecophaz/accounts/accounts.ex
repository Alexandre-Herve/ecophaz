defmodule Ecophaz.Accounts do
  alias Ecophaz.Repo

  alias Ecophaz.Accounts.{
    AuthToken,
    User
  }

  import Ecto.Query

  def create_token(attrs \\ %{}) do
    %AuthToken{}
    |> AuthToken.changeset(attrs)
    |> Repo.insert()
  end

  def create_token_for_user(user, params) do
    user
    |> Ecto.build_assoc(:auth_tokens, params)
    |> Repo.insert()
  end

  def get_token!(id), do: Repo.get!(AuthToken, id)

  def get_token_by(params) do
    AuthToken
    |> preload(:user)
    |> Repo.get_by(params)
  end

  def delete_token(%AuthToken{} = token) do
    Repo.delete(token)
  end

  def change_token(%AuthToken{} = token) do
    AuthToken.changeset(token, %{})
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by(params) do
    User |> Repo.get_by(params)
  end

  @spec create_user(Map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
