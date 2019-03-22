defmodule Example.TransactionsTest do
  use Example.DataCase, async: false

  alias Example.Repo
  alias Example.User
  alias Example.Transaction
  alias Example.Transactions

  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @id_two "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"
  @password "abcd1234"
  @user_one %{id: @id, username: "toran", password: @password}
  @user_two %{id: @id_two, username: "jarrod", password: @password}
  @date ~N[2019-01-01 01:00:00]
  @transaction_one %{description: "one", amount: 100, user_id: @id}
  @transaction_two %{description: "two", amount: 200, user_id: @id_two}
  @transaction_three %{description: "three", amount: 300, user_id: @id}

  test "all will return only transactions for the given user_id" do
    insert_users([@user_one, @user_two])
    insert_transactions([@transaction_one, @transaction_two, @transaction_three])

    transactions = Transactions.all(@user_one.id)
    assert Enum.count(transactions) == 2
    %Transaction{:description => description} = Enum.find(transactions, fn(t) -> t.amount == 100 end)
    assert description == "one"
    %Transaction{:description => description} = Enum.find(transactions, fn(t) -> t.amount == 300 end)
    assert description == "three"

    transactions = Transactions.all(@user_two.id)
    assert Enum.count(transactions) == 1
    %Transaction{:description => description} = Enum.find(transactions, fn(t) -> t.amount == 200 end)
    assert description == "two"
  end

  defp insert_users(users) do
    Enum.each(users, fn(attrs) ->
      %User{}
        |> User.changeset(attrs)
        |> Repo.insert
    end)
  end

  defp insert_transactions(transactions) do
    Enum.each(transactions, fn(transaction) ->
      transaction |> Map.put(:date, @date) |> Transactions.insert
    end)
  end

end
