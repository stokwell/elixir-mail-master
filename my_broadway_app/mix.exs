defmodule MyBroadwayApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_broadway_app,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amqp, "~> 3.3"},
      {:faker, "~> 0.17.0"},
      {:telemetry, "~> 1.0"},
      {:broadway, "~> 1.0"},
      {:broadway_rabbitmq, "~> 0.7"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:gen_rmq, "~> 2.3.0"}
    ]
  end
end
