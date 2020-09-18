defmodule EdJsonDbLoader.MixProject do
  use Mix.Project

  def project do
    [
      app: :ed_json_db_loader,
      version: "0.1.0",
      elixir: "~> 1.10",
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
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:geo_postgis, "~> 3.1"},
      {:jason, "~> 1.2"}
    ]
  end
end
