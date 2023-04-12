defmodule EctoIPRange.MixProject do
  use Mix.Project

  @url_changelog "https://hexdocs.pm/ecto_ip_range/changelog.html"
  @url_github "https://github.com/mneudert/ecto_ip_range"
  @version "0.3.0-dev"

  def project do
    [
      app: :ecto_ip_range,
      name: "Ecto IP Range",
      version: @version,
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      deps: deps(),
      description: "Ecto/Postgrex IP4R extension",
      dialyzer: dialyzer(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: :dev, runtime: false},
      {:dialyxir, "~> 1.3", only: :dev, runtime: false},
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.16.0", only: :test, runtime: false},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :underspecs,
        :unmatched_returns
      ],
      plt_core_path: "plts",
      plt_local_path: "plts"
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md",
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      formatters: ["html"],
      groups_for_modules: [
        "Ecto Types": [
          EctoIPRange.IP4,
          EctoIPRange.IP4R,
          EctoIPRange.IP6,
          EctoIPRange.IP6R,
          EctoIPRange.IPRange
        ],
        "Postgrex Extensions": [
          EctoIPRange.Postgrex.IP4Extension,
          EctoIPRange.Postgrex.IP4RExtension,
          EctoIPRange.Postgrex.IP6Extension,
          EctoIPRange.Postgrex.IP6RExtension,
          EctoIPRange.Postgrex.IPRangeExtension
        ]
      ],
      main: "EctoIPRange",
      source_ref: "v#{@version}",
      source_url: @url_github
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache-2.0"],
      links: %{
        "Changelog" => @url_changelog,
        "GitHub" => @url_github
      }
    ]
  end
end
