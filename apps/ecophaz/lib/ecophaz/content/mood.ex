defmodule Ecophaz.Content.Mood do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecophaz.Accounts

  @optional_fields ~w()a
  @required_fields ~w(text type)a

  schema "moods" do
    field :text, :string
    field :type, :string
    belongs_to :user, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(mood, attrs) do
    mood
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
