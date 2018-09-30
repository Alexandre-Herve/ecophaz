# Since configuration is shared in umbrella projects, this file
# should only configure the :ecophaz application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :ecophaz, :auth,
  seed: System.get_env("AUTH_SEED"),
  secret: System.get_env("AUTH_SECRET")
