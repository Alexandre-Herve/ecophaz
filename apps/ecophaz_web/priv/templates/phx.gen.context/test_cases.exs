
  describe "<%= schema.plural %>" do
    alias <%= inspect schema.module %>

    test "list_<%= schema.plural %>/0 returns all <%= schema.plural %>" do
      user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user: user)
      <%= schema.plural %> = <%= inspect context.alias %>.list_<%= schema.plural %>
      assert <%= schema.plural %> |> Enum.map(& &1.id) == [<%= schema.singular %>] |> Enum.map(& &1.id)
      assert <%= schema.plural %> |> List.first() |> Map.get(:user)
    end

    test "get_<%= schema.singular %>!/1 returns the <%= schema.singular %> with given id" do
      user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user: user)
      assert <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= schema.singular %>.id).id == <%= schema.singular %>.id
    end

    test "create_<%= schema.singular %>/1 with valid data creates a <%= schema.singular %>" do
      user = get_user()
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>, user_id: user.id)
      assert {:ok, %<%= inspect schema.alias %>{} = <%= schema.singular %>} = <%= inspect context.alias %>.create_<%= schema.singular %>(<%= schema.singular %>_params)<%= for {field, value} <- schema.params.create do %>
      assert <%= schema.singular %>.<%= field %> == <%= schema.singular %>_params.<%= field %><% end %>
    end

    test "create_<%= schema.singular %>/1 with invalid data returns error changeset" do
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>) |> invalidate
      assert {:error, %Ecto.Changeset{}} = <%= inspect context.alias %>.create_<%= schema.singular %>(<%= schema.singular %>_params)
    end

    test "update_<%= schema.singular %>/2 with valid data updates the <%= schema.singular %>" do
      user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user: user)
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>)

      <%= for {field, _value} <- schema.params.update do %><%= field %> = <%=schema.singular %>_params.<%= field %>
      <% end %>

      assert {:ok,
        %<%= inspect schema.alias %>{<%= for {field, _value} <- schema.params.update do %>
                                    <%= field %>: ^<%= field %>,<% end %>
                                    } = <%= schema.singular %>} = <%= inspect context.alias %>.update_<%= schema.singular %>(<%= schema.singular %>, <%= schema.singular %>_params)

    end

    test "update_<%= schema.singular %>/2 with invalid data returns error changeset" do
      user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user: user)
      <%= schema.singular %>_params = build(:<%= schema.singular %>) |> invalidate
      assert {:error, %Ecto.Changeset{}} = <%= inspect context.alias %>.update_<%= schema.singular %>(<%= schema.singular %>, <%= schema.singular %>_params)
    end

    test "delete_<%= schema.singular %>/1 deletes the <%= schema.singular %>" do
      user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user: user)
      assert {:ok, %<%= inspect schema.alias %>{}} = <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= schema.singular %>)
      assert_raise Ecto.NoResultsError, fn -> <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= schema.singular %>.id) end
    end

    test "change_<%= schema.singular %>/1 returns a <%= schema.singular %> changeset" do
      user = get_user()
      <%= schema.singular %> = insert(:<%= schema.singular %>, user: user)
      assert %Ecto.Changeset{} = <%= inspect context.alias %>.change_<%= schema.singular %>(<%= schema.singular %>)
    end
  end
