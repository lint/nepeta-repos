defmodule Crypt3 do
  @on_load :init
  @moduledoc """
  Documentation for Crypt3.
  """
  app = Mix.Project.config[:app]
  
  def init do
    path = :filename.join(:code.priv_dir(unquote(app)), 'nif')
    :ok = :erlang.load_nif(path, 0)
  end

  @doc """
  Encodes `pw` using `salt` with a crypt(3) implementation.

  ## Examples

      iex> Crypt3.crypt("aaaaaaaa", "aa")
      "aakcR08PK3l1o"

  """
  def crypt(_, _) do
    exit(:nif_library_not_loaded)
  end
end
