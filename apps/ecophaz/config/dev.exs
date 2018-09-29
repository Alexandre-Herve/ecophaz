# Since configuration is shared in umbrella projects, this file
# should only configure the :ecophaz application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :ecophaz, Ecophaz.Repo,
  username: "postgres",
  password: "postgres",
  database: "ecophaz_dev",
  hostname: "localhost",
  port: "5433",
  pool_size: 10
