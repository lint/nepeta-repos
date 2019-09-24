defmodule Crypt3Test do
  use ExUnit.Case
  doctest Crypt3

  test "some basic crypt" do
    assert Crypt3.crypt("aaaaaaaa", "aa") == "aakcR08PK3l1o"
  end

  test "shiftjis" do
    assert Crypt3.crypt(<<139, 227, 143, 240, 131, 74, 131, 140, 131, 147>>, "..") == "..ZfcbAkxpyA2"
  end
end
