defmodule Checkpoint.MixProject do
  use Mix.Project

  def project do
    [
      app: :checkpoint,
      version: "0.1.1",
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
      {:plug, ">= 1.0.0"},
      {:phoenix, ">= 1.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    A plug that handles authorization in phoenix applications via policy modules.
    """
  end

  defp package do
    [
      maintainers: ["tomciopp"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/tomciopp/checkpoint"}
    ]
  end
end
