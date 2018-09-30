# Since configuration is shared in umbrella projects, this file
# should only configure the :ecophaz application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :ecophaz, Ecophaz.Repo,
  database: "ecophaz_test",
  hostname: "localhost",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: "5433",
  username: "postgres"

config :ecophaz, :auth,
  seed: "user_token",
  secret: "CHANGE_ME_k7kTxvFAgeBvAVA0OR1vkPbTi8mZ5m"
