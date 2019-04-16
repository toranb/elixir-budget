defmodule Example.Clusters do
  import Ecto.Query, warn: false

  alias Example.Repo
  alias Example.Cluster

  def all do
    Repo.all(Cluster)
  end

  def upsert_by(attrs) do
    case Repo.get_by(Cluster, attrs) do
      nil -> %Cluster{}
      cluster -> cluster
    end
    |> Cluster.changeset(attrs)
    |> Repo.insert_or_update
  end
end
