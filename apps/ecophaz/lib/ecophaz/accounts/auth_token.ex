defmodule Ecophaz.Accounts.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecophaz.Accounts.User

  @optional_fields ~w()a
  @required_fields ~w(token)a

  schema "auth_tokens" do
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:token)
  end
end
