# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :app,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: Map.fetch!(System.get_env(), "APP_HOST")],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: App.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# config :ex_aws,
#   access_key_id: [{:system, System.get_env("AWS_ACCESS_KEY_ID")}, :instance_role],
#   secret_access_key: [{:system, System.get_env("AWS_SECRET_ACCESS_KEY")}, :instance_role],
#   region: "eu-west-2"

# Configure :ex_aws - Taken from JC tutorial
# Or take the version from ex-aws? with instance_role
config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  s3: [
   scheme: "https://",
   host: "dwyl-github-backup.s3.amazonaws.com",
   region: "eu-west-2"
  ]

config :app, :github_app_name, Map.fetch!(System.get_env(), "GITHUB_APP_NAME")


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
