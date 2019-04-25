defmodule Example.HashTest do
  use ExUnit.Case, async: true

  alias Example.Hash

  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @id_two "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"

  test "hmac will generate the same value for key consistently" do
    one = Hash.hmac(:user, "toran")
    assert one == @id

    two = Hash.hmac(:user, "toran")
    assert two == @id

    other = Hash.hmac(:other, "toran")
    assert other != @id

    jarrod = Hash.hmac(:user, "jarrod")
    assert jarrod == @id_two
  end
end
