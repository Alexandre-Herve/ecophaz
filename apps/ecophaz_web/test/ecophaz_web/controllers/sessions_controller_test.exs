defmodule EcophazWeb.SessionsControllerTest do
  use EcophazWeb.ConnCase
  import Ecophaz.Factory
  alias Ecophaz.{Accounts}

  test "create session returns 401 with wrong password", %{conn: conn} do
    params = %{"email" => "test", "password" => "test"}
    conn = post(conn, Routes.sessions_path(conn, :create, params))
    assert response(conn, 401)
  end

  test "create session returns token", %{conn: conn} do
    user = get_user()
    params = %{"email" => user.email, "password" => "Azerty12"}
    conn = post(conn, Routes.sessions_path(conn, :create, params))
    assert %{"data" => %{"token" => _token}} = json_response(conn, 200)
  end

  test "delete session sends 400 without headers", %{conn: conn} do
    # user = get_user()
    # params = %{"email" => user.email, "password" => "Azerty12"}
    # Accounts.sign_in(user.email, "Azerty12")
    conn = delete(conn, Routes.sessions_path(conn, :delete))
    assert response(conn, 400)
  end

  test "delete session sends 401 with incorrect headers", %{conn: conn} do
    conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer 123")
      |> delete(Routes.sessions_path(conn, :delete))

    assert response(conn, 403)
  end

  test "delete session sends 204 for correct headers", %{conn: conn} do
    user = get_user()
    {:ok, token} = Accounts.sign_in(user.email, "Azerty12")

    conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{token.token}")
      |> delete(Routes.sessions_path(conn, :delete))

    assert response(conn, 204)
  end

  defp get_user do
    build(:user)
    |> Accounts.User.changeset(%{password: "Azerty12"})
    |> Repo.insert!()
  end
end
