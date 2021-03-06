defmodule Ecophaz.AccountsTest do
  use Ecophaz.DataCase
  import Ecophaz.Factory
  alias Ecophaz.Accounts

  describe "auth_tokens" do
    alias Ecophaz.Accounts.AuthToken

    test "create_token/1 with valid data creates a token" do
      user = insert(:user)
      token_params = params_for(:auth_token, user_id: user.id)
      assert {:ok, %AuthToken{} = token} = Accounts.create_token(token_params)
      assert token.token == token_params.token
    end

    test "delete_token/1 deletes the token" do
      user = insert(:user)
      token = insert(:auth_token, user: user)
      assert {:ok, %AuthToken{}} = Accounts.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      user = insert(:user)
      token = insert(:auth_token, user: user)
      assert %Ecto.Changeset{} = Accounts.change_token(token)
    end
  end

  describe "users" do
    alias Ecophaz.Accounts.User

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id).id == user.id
    end

    test "create_user creates a user" do
      user_params = %{
        name: "Alfred",
        email: "coucou@lol.com",
        password: "Azerty12"
      }

      assert {:ok, %User{}} = Accounts.create_user(user_params)
    end
  end
end
