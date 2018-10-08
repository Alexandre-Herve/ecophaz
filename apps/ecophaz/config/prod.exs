# Since configuration is shared in umbrella projects, this file
# should only configure the :ecophaz application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :phoenix, :filter_parameters, [
  "password",
  "password_confirmation",
  "name",
  "email"
]
