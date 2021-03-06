# Since configuration is shared in umbrella projects, this file
# should only configure the :ecophaz_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ecophaz_web, EcophazWeb.Endpoint,
  http: [port: 4001],
  server: false

config :ecophaz_web, :auth,
  seed: "user_token",
  secret: "CHANGE_ME_k7kTxvFAgeBvAVA0OR1vkPbTi8mZ5m"

config :ecophaz_web, EcophazWeb.Mailer, adapter: Bamboo.TestAdapter
