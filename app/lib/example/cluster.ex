defmodule Example.Cluster do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "clusters" do

    timestamps()
  end

  def changeset(cluster, attrs) do
    cluster
      |> cast(attrs, [:id])
  end

end
