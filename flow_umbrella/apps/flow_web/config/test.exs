use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :flow_web, FlowWeb.Endpoint,
  http: [port: 4001],
  server: false
