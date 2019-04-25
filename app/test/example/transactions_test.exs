defmodule Example.TransactionsTest do
  use Example.DataCase, async: false

  alias Example.Repo
  alias Example.User
  alias Example.Categories
  alias Example.Transaction
  alias Example.Transactions

  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @id_two "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"
  @password "abcd1234"
  @user_one %{id: @id, username: "toran", password: @password}
  @user_two %{id: @id_two, username: "jarrod", password: @password}
  @category_id_one "acbd18db4cc2f85cedef654fccc4a4d8"
  @category_id_two "37b51d194a7513e45b56f6524f2d51f2"
  @date ~N[2019-01-01 01:00:00]
  @category_one %{id: @category_id_one, name: "foo"}
  @category_two %{id: @category_id_two, name: "bar"}
  @transaction_one %{description: "one", amount: 100, user_id: @id, category_id: @category_id_one}
  @transaction_two %{
    description: "two",
    amount: 200,
    user_id: @id_two,
    category_id: @category_id_two
  }
  @transaction_three %{
    description: "three",
    amount: 300,
    user_id: @id,
    category_id: @category_id_one
  }

  test "all will return only transactions for the given user_id" do
    insert_categories([@category_one, @category_two])
    insert_users([@user_one, @user_two])
    insert_transactions([@transaction_one, @transaction_two, @transaction_three])

    transactions = Transactions.all(@user_one.id)
    assert Enum.count(transactions) == 2

    %Transaction{:description => description, category_id: category_id} =
      Enum.find(transactions, fn t -> t.amount == 100 end)

    assert description == "one"
    assert category_id == @category_id_one

    %Transaction{:description => description, category_id: category_id} =
      Enum.find(transactions, fn t -> t.amount == 300 end)

    assert description == "three"
    assert category_id == @category_id_one

    transactions = Transactions.all(@user_two.id)
    assert Enum.count(transactions) == 1

    %Transaction{:description => description, category_id: category_id} =
      Enum.find(transactions, fn t -> t.amount == 200 end)

    assert description == "two"
    assert category_id == @category_id_two
  end

  test "insert will hydrate associated category" do
    insert_categories([@category_one])
    insert_users([@user_one])

    result = @transaction_one |> Map.put(:date, @date) |> Transactions.insert()

    {:ok, %Transaction{description: description, amount: amount, date: date, category: category}} =
      result

    assert description == "one"
    assert amount == 100
    assert date == @date
    %Example.Category{id: id, name: name} = category
    assert id == @category_id_one
    assert name == "foo"
  end

  defp insert_users(users) do
    Enum.each(users, fn attrs ->
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    end)
  end

  defp insert_transactions(transactions) do
    Enum.each(transactions, fn transaction ->
      transaction |> Map.put(:date, @date) |> Transactions.insert()
    end)
  end

  defp insert_categories(categories) do
    Enum.each(categories, fn category ->
      Categories.insert!(category)
    end)
  end
end
