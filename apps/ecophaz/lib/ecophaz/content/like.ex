defmodule Ecophaz.Content.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecophaz.Accounts.{User}
  alias Ecophaz.Content.{Mood}

  @required_fields ~w(user_id)a
  @optional_fields ~w(mood_id)a

  schema "likes" do
    belongs_to :user, User
    belongs_to :mood, Mood

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
