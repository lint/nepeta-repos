defmodule Tripcode do
  @moduledoc """
  Documentation for Tripcode.
  """

  @doc """
  Generates a tripcode..

  ## Examples

      iex> Tripcode.make "廨A齬ﾙｲb"
      "sTrIKeleSs"

  """
  def make(str) do
    sjis = Enum.reduce(String.graphemes(str), "", fn(x, a) ->
      char = :iconv.convert "utf-8", "shift-jis", x
      case char != "" do
        true -> a <> char
        _ -> a <> "?"
      end
    end)
      |> String.replace("&", "&amp;")
      |> String.replace("\"", "&quot;")
      |> String.replace("<", "&lt;")
      |> String.replace(">", "&gt;")
    salt = String.slice(sjis <> "H.", 1..2)
      |> String.replace(~r/[^\.-z]/, ".")
      |> String.replace(":", "A")   #until i figure out something better ;_;
      |> String.replace(";", "B")
      |> String.replace("<", "C")
      |> String.replace("=", "D")
      |> String.replace(">", "E")
      |> String.replace("?", "F")
      |> String.replace("@", "G")
      |> String.replace("[", "a")
      |> String.replace("\\", "b")
      |> String.replace("]", "c")
      |> String.replace("^", "d")
      |> String.replace("_", "e")
      |> String.replace("`", "f")
    padded_sjis = String.pad_trailing(sjis, 8, <<0>>)
    padded_salt = String.pad_trailing(salt, 2, <<0>>)
    String.slice(Crypt3.crypt(padded_sjis, padded_salt), -10..-1)
  end
end
