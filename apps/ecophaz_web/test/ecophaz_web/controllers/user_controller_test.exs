defmodule EcophazWeb.AuthControllerTest do
  use EcophazWeb.ConnCase

  import Ecophaz.Factory

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
end
