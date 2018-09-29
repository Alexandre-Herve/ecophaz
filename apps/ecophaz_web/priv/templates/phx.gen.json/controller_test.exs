defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>ControllerTest do

  use <%= inspect context.web_module %>.ConnCase
  import <%= inspect context.base_module %>.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :logged_in
    test "lists all <%= schema.plural %>", %{conn: conn} do
      <%= schema.singular %>_1 = insert(:<%= schema.singular %>)
      <%= schema.singular %>_2 = insert(:<%= schema.singular %>)
      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :index))
      res = json_response(conn, 200)["data"]
      assert <%= schema.singular %>_1.id in (res |> Enum.map(&(&1 |> Map.get("id"))))
      assert <%= schema.singular %>_2.id in (res |> Enum.map(&(&1 |> Map.get("id"))))
    end
  end

  describe "create <%= schema.singular %>" do
    @tag :logged_in
    test "renders <%= schema.singular %> when data is valid", %{conn: conn} do
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>)
      conn = post(conn, Routes.<%= schema.route_helper %>_path(conn, :create), <%= schema.singular %>: <%= schema.singular %>_params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :show, id))

      <%= for {key, _val} <- schema.params.create do %><%= key %> = <%= schema.singular %>_params.<%= key %>
      <% end %>

      assert %{
               "id" => id<%= for {key, val} <- schema.params.create do %>,
               "<%= key %>" => ^<%= key %><% end %>
             } = json_response(conn, 200)["data"]
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>) |> invalidate
      conn = post(conn, Routes.<%= schema.route_helper %>_path(conn, :create), <%= schema.singular %>: <%= schema.singular %>_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update <%= schema.singular %>" do
    @tag :logged_in
    test "doesn't update someone else's <%= schema.singular %>", %{conn: conn, user: user} do
      other_user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user_id: other_user.id)
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>, user_id: user.id)
      conn = put(conn, Routes.<%= schema.singular %>_path(conn, :update, <%= schema.singular %>), <%= schema.singular %>: <%= schema.singular %>_params)
      assert json_response(conn, 403)
    end

    @tag :logged_in
    test "renders <%= schema.singular %> when data is valid", %{conn: conn, user: user} do
      <%= schema.singular %> = insert(:<%= schema.singular %>, user_id: user.id)
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>)

      conn = put(conn, Routes.<%= schema.route_helper %>_path(conn, :update, <%= schema.singular %>), <%= schema.singular %>: <%= schema.singular %>_params)

      id = <%= schema.singular %>.id
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.<%= schema.route_helper %>_path(conn, :show, id))

      <%= for {key, _val} <- schema.params.update do %><%= key %> = <%= schema.singular %>_params.<%= key %>
      <% end %>

      assert %{
               "id" => id<%= for {key, val} <- schema.params.update do %>,
               "<%= key %>" => ^<%= key %><% end %>
             } = json_response(conn, 200)["data"]
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      <%= schema.singular %> = insert(:<%= schema.singular %>, user_id: user.id)
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>) |> invalidate

      conn = put(conn, Routes.<%= schema.route_helper %>_path(conn, :update, <%= schema.singular %>), <%= schema.singular %>: <%= schema.singular %>_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete <%= schema.singular %>" do
    @tag :logged_in
    test "doesn't delete someone else's <%= schema.singular %>", %{conn: conn} do
      other_user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user_id: other_user.id)
      conn = delete(conn, Routes.<%= schema.singular %>_path(conn, :delete, <%= schema.singular %>))
      assert json_response(conn, 403)
    end

    @tag :logged_in
    test "deletes chosen <%= schema.singular %>", %{conn: conn, user: user} do
      <%= schema.singular %> = insert(:<%= schema.singular %>, user_id: user.id)
      conn = delete(conn, Routes.<%= schema.route_helper %>_path(conn, :delete, <%= schema.singular %>))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.<%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
      end
    end
  end
end
