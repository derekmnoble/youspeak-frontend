# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :you_speak,
  ecto_repos: [YouSpeak.Repo]

# Configures the endpoint
config :you_speak, YouSpeakWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b5l5fwNvPoUItupXkitJEjlSC6ogxJfbdhbOb3vx9BBdP7xDHPG36AfPcxsx9vjo",
  render_errors: [view: YouSpeakWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: YouSpeak.PubSub,
  live_view: [signing_salt: "Uc+MXKIv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# OAuth configs
config :ueberauth, Ueberauth,
  providers: [
    google: { Ueberauth.Strategy.Google, [] }
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "479567242273-r35r1qkcjmpjnecaeo79mhpvhtt04p9h.apps.googleusercontent.com",
  client_secret: "RBBh-tbEv83w_Th-mv-zPlwD"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
