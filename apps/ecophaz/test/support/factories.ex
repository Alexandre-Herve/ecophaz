defmodule Ecophaz.Factory do
  use ExMachina.Ecto, repo: Ecophaz.Repo

  alias Ecophaz.{Accounts, Content, Repo}

  # Auth
  def auth_token_factory do
    %Accounts.AuthToken{
      revoked: false,
      revoked_at: DateTime.utc_now(),
      token: sequence(:token, &"token-#{&1}")
    }
  end

  def user_factory do
    %Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      name: sequence(:name, &"Alfred#{&1}")
    }
  end

  def get_user do
    build(:user)
    |> Accounts.User.changeset(%{password: "Azerty12"})
    |> Repo.insert!()
  end

  # Content
  def mood_factory do
    %Content.Mood{
      text: sequence(:text, &"text-#{&1}"),
      type: "joy"
    }
  end

  # Helpers
  def invalidate(build) do
    build
    |> Map.keys()
    |> Enum.map(&{&1, nil})
    |> Enum.into(%{})
    |> Map.drop([:__meta__, :__struct__])
  end
end
