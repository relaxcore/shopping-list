defmodule TestTask.ShopList.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias TestTask.ShopList.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "categories" do
    field :name, :string
    timestamps()

    has_many :items, Item
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
