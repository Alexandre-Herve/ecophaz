defmodule Ecophaz.Repo do
  use Ecto.Repo,
    otp_app: :ecophaz,
    adapter: Ecto.Adapters.Postgres
end
