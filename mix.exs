defmodule Accountable.MixProject do
  use Mix.Project

  def project do
    [
      app: :accountable,
      version: "0.2.1",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      dialyzer: dialyzer()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:comeonin, "~> 5.1.1"},
      {:argon2_elixir, "~> 2.0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:guardian, "~> 1.0"},
      {:ecto_sql, "~> 3.2"},
      {:postgrex, ">= 0.0.0", only: :test},
      {:dialyxir, "~> 0.4", only: :test},
      {:ex_machina, "~> 2.3", only: :test},
      {:absinthe_plug, "~> 1.4", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate"]
    ]
  end

  defp package do
    %{
      description: "User accounts boilerplate.",
      maintainers: ["Robert Falkén"],
      licenses: ["MIT"],
      links: %{
        github: "https://github.com/robertfalken/accountable"
      }
    }
  end

  defp dialyzer do
    [plt_add_apps: [:ex_unit]]
  end
end
