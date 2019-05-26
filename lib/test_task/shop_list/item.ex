defmodule TestTask.ShopList.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias TestTask.ShopList.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "items" do
    field :bougth, :boolean, default: false
    field :name, :string
    field :price, :float
    timestamps()

    belongs_to :category, Category
  end

  @doc false
  def create_changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
    |> unique_constraint(:name)
    |> validate_number(:price, greater_than: 0)
  end

    @doc false
    def update_changeset(item, attrs) do
      item
      |> cast(attrs, [:name, :price, :bougth])
      |> unique_constraint(:name)
      |> validate_number(:price, greater_than: 0)
    end
end
