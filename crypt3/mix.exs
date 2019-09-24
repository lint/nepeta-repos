defmodule Mix.Tasks.Compile.Nif do
  def run(_args) do
    {result, _errcode} = System.cmd("make", [])
    IO.binwrite(result)
  end
end

defmodule Crypt3.Mixfile do
  use Mix.Project

  def project do
    [
      app: :crypt3,
      compilers: [:nif] ++ Mix.compilers,
      version: "1.0.4",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      build_embedded: true,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: "https://github.com/ominousness/crypt3"
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
      {:ex_doc, ">= 0.0.0", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description do
    "crypt(3) NIF for Elixir."
  end

  defp package do
    [
      files: ["lib", "c_src", "mix.exs", "README.md", "Makefile", "LICENSE", "config", "test", "priv"],
      maintainers: ["Ominousness"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ominousness/crypt3"}
    ]
  end
end
