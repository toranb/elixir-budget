defmodule Example.StorageTest do
  use ExUnit.Case, async: false

  alias Example.Storage

  setup do
    Storage.flush()

    :ok
  end

  test "Redix will set & get key value pairs" do
    {:ok, value} = Storage.get("x")
    assert value == nil

    :ok = Storage.set("x", "foo")

    {:ok, value} = Storage.get("x")
    assert value == "foo"
  end

end
