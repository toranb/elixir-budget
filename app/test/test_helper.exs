:ok = LocalCluster.start()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Example.Repo, :manual)
