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
      {:agala, "~> 2.0.2"},
      {:ex_doc, "> 0.0.0", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test]}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
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
