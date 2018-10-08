defmodule Ecophaz.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecophaz.Accounts.{AuthToken}
  alias Ecophaz.Content.{Like, Mood}

  defimpl Inspect do
    @sensitive_fields [
      :name,
      :email
    ]
    def inspect(user, opts) do
      user
      |> Map.drop(@sensitive_fields)
      |> Inspect.Any.inspect(opts)
    end
  end

  @required_fields ~w(email password name)a
  @optional_fields ~w()a

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    has_many(:auth_tokens, AuthToken)
    has_many(:moods, Mood)
    many_to_many(:liked_moods, Mood, join_through: Like)

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
