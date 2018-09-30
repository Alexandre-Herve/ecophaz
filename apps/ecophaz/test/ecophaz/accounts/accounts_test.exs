defmodule Ecophaz.AccountsTest do
  use Ecophaz.DataCase
  import Ecophaz.Factory
  alias Ecophaz.Accounts
  alias Ecophaz.Accounts.{AuthToken, User}
  alias Ecophaz.Repo

  test "sign_in is successful with correct password" do
    user = get_user()
    user_id = user.id

    assert {:ok, %Accounts.AuthToken{user_id: ^user_id}} =
             Accounts.sign_in(user.email, "Azerty12")
  end

  test "sign_in fails with wrong password" do
    user = get_user()
    assert {:error, "invalid password"} = Accounts.sign_in(user.email, "Passw0rd")
  end

  test "sign_out with invalid token fails" do
    assert {:error, :invalid_auth_header} = Accounts.sign_out("invalid")
  end

  test "sign_out with valid token succeeds" do
    user = get_user()
    {:ok, token} = Accounts.sign_in(user.email, "Azerty12")
    assert {:ok, %AuthToken{}} = Accounts.sign_out(token.token)
  end

  test "get_token return token with preloaded user for existing valid token" do
    user = get_user()
    user_id = user.id
    {:ok, token} = Accounts.sign_in(user.email, "Azerty12")
    assert %AuthToken{user: %User{id: ^user_id}} = Accounts.get_token(token.token)
  end

  test "get_token returns nil for unknown token" do
    assert is_nil(Accounts.get_token("123"))
  end

  defp get_user do
    build(:user)
    |> Accounts.User.changeset(%{password: "Azerty12"})
    |> Repo.insert!()
  end
end
