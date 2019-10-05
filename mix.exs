defmodule EctoIPRange.MixProject do
  use Mix.Project

  @url_github "https://github.com/mneudert/ecto_ip_range"

  def project do
    [
      app: :ecto_ip_range,
      name: "Ecto IP Range",
      version: "0.1.0-dev",
      elixir: "~> 1.7",
      deps: deps(),
      description: "Ecto IP Range",
      docs: docs(),
      package: package()
    ]
  end

  def application, do: []

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "EctoIPRange",
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
