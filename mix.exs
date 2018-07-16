defmodule AgalaEmail.MixProject do
  use Mix.Project

  def project do
    [
      app: :agala_email,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
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
      {:agala, git: "https://github.com/agalaframework/agala", branch: "feature/module-init"},
      {:ex_doc, "> 0.0.0", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test]},
      {:pop3mail, "~> 1.3"},
      {:erlpop, github: "nico-amsterdam/erlpop"},
      {:bamboo, "~> 0.8"}
    ]
  end

  defp description do
    """
    Email provider for Agala framework.
    """
  end

  defp package do
    [
      maintainers: ["d4rk5eed", "Dmitry Rubinstein"],
      licenses: ["MIT"],
      files: ~w(mix.exs README* CHANGELOG* lib)
    ]
  end
end
