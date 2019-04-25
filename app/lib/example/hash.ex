defmodule Example.Hash do
  def hmac(key, value) do
    string = Atom.to_string(key)

    :crypto.hmac(:sha256, string, value)
    |> Base.encode16()
  end
end
