defmodule Ecophaz.Content.Mood do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecophaz.Accounts.{User}
  alias Ecophaz.Content.{Like}

  @required_fields ~w(text type user_id)a
  @optional_fields ~w(image)a
  @types ~w(joy anger)

  schema "moods" do
    belongs_to :user, User
    field :image, :string
    field :text, :string
    field :type, :string
    has_many :likes, Like
    many_to_many :likers, User, join_through: Like

    timestamps()
  end

  @doc false
  def changeset(mood, attrs) do
    mood
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:type, @types)
  end
end
