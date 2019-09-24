defmodule TripcodeTest do
  use ExUnit.Case
  doctest Tripcode

  test "shift-jis characters" do
    assert Tripcode.make("廨A齬ﾙｲb") == "sTrIKeleSs"
    assert Tripcode.make("]lzD冫pｺ") == "ASCENDENCY"
    assert Tripcode.make("ДДДД") == "C/4xGjRvcc"
    assert Tripcode.make("ΛΛΛΛ") == "PdMfrEj6Bw"
  end

  test "characters outside of shift-jis" do
    assert Tripcode.make("ęęęę") == "Vyfxi/dpqw"
    assert Tripcode.make("😋😋😋😋") == "Vyfxi/dpqw"
  end

  test "ASCII characters" do
    assert Tripcode.make("d'H~I_CA") == "qDASHIEwag"
    assert Tripcode.make("K4YVVGeZ") == "chewstickM"
    assert Tripcode.make("sgtU>vnt") == "OGQ3GI/4oU"
    assert Tripcode.make("Jz>L5N%j") == "9WaILRcnB2"
  end

  test "html entities" do
    assert Tripcode.make("&&&&") == "sS3IIIdY12"
    assert Tripcode.make("<<<<") == "wZLr7yNcBc"
    assert Tripcode.make(">>>>") == "FdL1jBqM3g"
    assert Tripcode.make("\"\"\"\"") == "1rr8HU7DiE"
  end
end
