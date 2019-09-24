# crypt3

crypt(3) NIF for Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `crypt3` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:crypt3, "~> 1.0.4"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/crypt3](https://hexdocs.pm/crypt3).

## Usage

```elixir
iex> Crypt3.crypt("aaaaaaaa", "aa")
"aakcR08PK3l1o"
```