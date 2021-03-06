defmodule <%= inspect schema.module %> do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(<%= Enum.map_join(schema.attrs, " ", & (&1 |> elem(0) |> to_string)) %>)a
  @optional_fields ~w()a

<%= if schema.binary_id do %>
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id<% end %>
  schema <%= inspect schema.table %> do
<%= for {k, v} <- schema.types do %>    field <%= inspect k %>, <%= inspect v %><%= schema.defaults[k] %>
<% end %><%= for {_, k, _, _} <- schema.assocs do %>    field <%= inspect k %>, <%= if schema.binary_id do %>:binary_id<% else %>:id<% end %>
<% end %>
    timestamps()
  end

  @doc false
  def changeset(<%= schema.singular %>, attrs) do
    <%= schema.singular %>
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
<%= for k <- schema.uniques do %>    |> unique_constraint(<%= inspect k %>)
<% end %>  end
end
