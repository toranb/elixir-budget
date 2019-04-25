defmodule ExampleWeb.ClusterTest do
  use Example.DataCase, async: false

  @node1 "http://localhost:4001"
  @node2 "http://localhost:4002"
  @password "abcd1234"

  setup do
    LocalCluster.start()

    System.put_env("EXAMPLE1_PORT", "4001")
    System.put_env("EXAMPLE2_PORT", "4002")

    launch_server()

    on_exit fn ->
      Example.Repo.delete_all(Example.User)
    end

    {:ok, response: %HTTPoison.Response{}, login: %{username: random_string(), password: @password}}
  end

  test "login will authenticate the user regardless of node", %{response: response, login: login} do
    LocalCluster.start_nodes("example", 2)

    # create the user on node@1
    response = get(response, "#{@node1}/signup")
    assert response.status_code == 200
    response = post(response, "#{@node1}/signup", login)
    assert response.status_code == 302

    # authenticate w/ node@1
    response = get(response, "#{@node1}/")
    assert response.status_code == 200
    response = post(response, "#{@node1}/", login)
    assert response.status_code == 302
    response = get(response, "#{@node1}/budget")
    assert response.status_code == 200

    # authenticate w/ node@2
    eventually(fn ->
      response = get(%HTTPoison.Response{}, "#{@node2}/budget")
      assert response.status_code == 302
      response = get(response, "#{@node2}/")
      assert response.status_code == 200
      response = post(response, "#{@node2}/", login)
      assert response.status_code == 302
      response = get(response, "#{@node2}/budget")
      assert response.status_code == 200
    end)
  end

  test "authenticate works after network partition heals", %{response: response, login: login} do
    [n1, n2] = LocalCluster.start_nodes("example", 2)

    Schism.partition([n1])

    # create the user on node@1
    response = get(response, "#{@node1}/signup")
    assert response.status_code == 200
    response = post(response, "#{@node1}/signup", login)
    assert response.status_code == 302

    # authenticate w/ node@1
    response = get(response, "#{@node1}/")
    assert response.status_code == 200
    response = post(response, "#{@node1}/", login)
    assert response.status_code == 302
    response = get(response, "#{@node1}/budget")
    assert response.status_code == 200

    # node@2 split so authenticate fails
    response = get(%HTTPoison.Response{}, "#{@node2}/budget")
    assert response.status_code == 302
    response = get(response, "#{@node2}/")
    assert response.status_code == 200
    response = post(response, "#{@node2}/", login)
    assert response.status_code == 200

    Schism.heal([n1, n2])

    # node@2 heal so authenticate works
    eventually(fn ->
      response = get(%HTTPoison.Response{}, "#{@node2}/budget")
      response = get(response, "#{@node2}/")
      response = post(response, "#{@node2}/", login)
      assert response.status_code == 302
      response = get(response, "#{@node2}/budget")
      assert response.status_code == 200
    end)
  end

  def eventually(f, retries \\ 0) do
    f.()
  rescue
    err ->
      if retries >= 5 do
        raise err
      else
        :timer.sleep(200)
        eventually(f, retries + 1)
      end
  end

  def post(response, url, params) do
    %HTTPoison.Response{body: body, headers: headers} = response
    [ csrf_token ] = Floki.find(body, "input[name=_csrf_token]") |> Floki.attribute("value")
    payload = params |> Map.put(:_csrf_token, csrf_token)
    cookie = set_cookie(headers)

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    HTTPoison.post!(url, URI.encode_query(payload), headers, hackney: [cookie: [cookie]])
  end

  def get(response, url) do
    %HTTPoison.Response{headers: headers} = response
    cookie = set_cookie(headers)

    HTTPoison.get!(url, %{}, hackney: [cookie: [cookie]])
  end

  def set_cookie(headers) do
    if Enum.count(headers) > 0 do
      [ {_name, value} ] = Enum.filter(headers, fn
        {key, _} -> String.match?(key, ~r/\Aset-cookie\z/i)
      end)
      value
    else
      ""
    end
  end

  def launch_server do
    endpoint_config =
      Application.get_env(:example, ExampleWeb.Endpoint)
      |> Keyword.put(:server, true)
    :ok = Application.put_env(:example, ExampleWeb.Endpoint, endpoint_config)

    :ok = Application.stop(:example)
    :ok = Application.start(:example)
  end

  defp random_string do
    :crypto.strong_rand_bytes(10)
    |> Base.url_encode64
    |> binary_part(0, 10)
  end

end
