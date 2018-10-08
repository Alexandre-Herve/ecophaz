defmodule EcophazWeb.AuthControllerTest do
  use EcophazWeb.ConnCase
  use Bamboo.Test, shared: true

  import Ecophaz.Factory

  alias EcophazWeb.Services.Authenticator

  describe "create" do
    test "creates a user with valid data", %{conn: conn} do
      user_params = %{
        name: "Alfred",
        email: "test@lol.com",
        password: "Azerty12"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: user_params)
      assert json_response(conn, 201)["data"]["id"]
    end

    test "returns an error for invalid data", %{conn: conn} do
      user_params = %{
        name: "Alfred",
        email: "test@lol.com"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: user_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show" do
    test "returns 401 when not logged in", %{conn: conn} do
      user = insert(:user)
      conn = get(conn, Routes.user_path(conn, :show, user))
      assert response(conn, 401)
    end

    @tag :logged_in
    test "returns 200 when logged in", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show, user))
      assert json_response(conn, 200)["data"]["id"] == user.id
    end
  end

  describe "request_change_password" do
    test "sends an email with a reset token", %{conn: conn} do
      user = insert(:user)
      email = user.email
      params = %{email: email}
      post(conn, Routes.user_path(conn, :request_change_password), params)
      assert_email_delivered_with(to: [nil: email])
    end
  end

  describe "change_password" do
    test "changes user's password", %{conn: conn} do
      user = insert(:user)
      password = "Passw0rd!"
      token = Authenticator.generate_token("reset_password:#{user.id}")
      params = %{"token" => token, "password" => password}
      conn = post(conn, Routes.user_path(conn, :change_password), params)
      assert response(conn, 200)
      assert {:ok, _token} = Authenticator.sign_in(user.email, password)
    end

    test "returns an error for an invalid token", %{conn: conn} do
      params = %{"token" => "123", "password" => "1234"}
      conn = post(conn, Routes.user_path(conn, :change_password), params)
      assert response(conn, 404)
    end
  end
end
