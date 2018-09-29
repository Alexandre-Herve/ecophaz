# Since configuration is shared in umbrella projects, this file
# should only configure the :ecophaz_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :ecophaz_web,
  ecto_repos: [Ecophaz.Repo],
  generators: [context_app: :ecophaz]

# Configures the endpoint
config :ecophaz_web, EcophazWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eCnSAGL2sxu/kuCrKB2ndvsDVBT/yAR3Hks90VB6KV1JjSWxskGJkcrY8e3g6FMH",
  render_errors: [view: EcophazWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: EcophazWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
