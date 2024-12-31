import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :game_2048, Game2048Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "yMWr/nnubRQKaA8Bn+9qFitVFjAkeLcPmIL8u6wNHAoYFZ9j0eaDVNuzq2FDfWtG",
  server: false

# In test we don't send emails
config :game_2048, Game2048.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
