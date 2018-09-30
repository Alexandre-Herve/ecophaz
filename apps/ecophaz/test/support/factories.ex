defmodule Ecophaz.Factory do
  use ExMachina.Ecto, repo: Ecophaz.Repo

  alias Ecophaz.Accounts

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
end
