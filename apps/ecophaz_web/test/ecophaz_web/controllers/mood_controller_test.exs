defmodule EcophazWeb.MoodControllerTest do
  use EcophazWeb.ConnCase
  import Ecophaz.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :logged_in
    test "lists all moods", %{conn: conn} do
      mood_1 = insert(:mood)
      mood_2 = insert(:mood)
      conn = get(conn, Routes.mood_path(conn, :index))
      res = json_response(conn, 200)["data"]
      assert mood_1.id in (res |> Enum.map(&(&1 |> Map.get("id"))))
      assert mood_2.id in (res |> Enum.map(&(&1 |> Map.get("id"))))
    end
  end

  describe "create mood" do
    @tag :logged_in
    test "renders mood when data is valid", %{conn: conn} do
      mood_params = params_for(:mood)
      conn = post(conn, Routes.mood_path(conn, :create), mood: mood_params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.mood_path(conn, :show, id))

      text = mood_params.text
      type = mood_params.type

      assert %{
               "id" => id,
               "text" => ^text,
               "type" => ^type
             } = json_response(conn, 200)["data"]
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      mood_params = params_for(:mood) |> invalidate
      conn = post(conn, Routes.mood_path(conn, :create), mood: mood_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mood" do
    @tag :logged_in
    test "doesn't update someone else's mood", %{conn: conn, user: user} do
      other_user = get_user()
      mood = insert(:mood, user_id: other_user.id)
      mood_params = params_for(:mood, user_id: user.id)
      conn = put(conn, Routes.mood_path(conn, :update, mood), mood: mood_params)
      assert json_response(conn, 403)
    end

    @tag :logged_in
    test "renders mood when data is valid", %{conn: conn, user: user} do
      mood = insert(:mood, user_id: user.id)
      mood_params = params_for(:mood)

      conn = put(conn, Routes.mood_path(conn, :update, mood), mood: mood_params)

      id = mood.id
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.mood_path(conn, :show, id))

      text = mood_params.text
      type = mood_params.type

      assert %{
               "id" => id,
               "text" => ^text,
               "type" => ^type
             } = json_response(conn, 200)["data"]
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      mood = insert(:mood, user_id: user.id)
      mood_params = params_for(:mood) |> invalidate

      conn = put(conn, Routes.mood_path(conn, :update, mood), mood: mood_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete mood" do
    @tag :logged_in
    test "doesn't delete someone else's mood", %{conn: conn} do
      other_user = get_user()
      mood = insert(:mood, user_id: other_user.id)
      conn = delete(conn, Routes.mood_path(conn, :delete, mood))
      assert json_response(conn, 403)
    end

    @tag :logged_in
    test "deletes chosen mood", %{conn: conn, user: user} do
      mood = insert(:mood, user_id: user.id)
      conn = delete(conn, Routes.mood_path(conn, :delete, mood))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.mood_path(conn, :show, mood))
      end
    end
  end
end
