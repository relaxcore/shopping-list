use Mix.Config

# Configure your database
config :test_task, TestTask.Repo,
  username: System.get_env("PG_LOGIN"),
  password: System.get_env("PG_PASSWORD"),
  database: "test_task_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :test_task, TestTaskWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
