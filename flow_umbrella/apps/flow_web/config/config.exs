# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :flow_web,
  namespace: FlowWeb

# Configures the endpoint
config :flow_web, FlowWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "thxZvEpL1010Qux2u7vh8VrPIZXfMbHGdYst1s/MfiNO1viR4f/ah62vuAhq5FJt",
  render_errors: [view: FlowWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: FlowWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :flow_web, :generators,
  context_app: :flow

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
