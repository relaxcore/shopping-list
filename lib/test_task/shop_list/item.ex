defmodule TestTask.ShopList.Item do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias TestTask.Repo
  alias TestTask.ShopList.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "items" do
    field :bought, :boolean, default: false
    field :name, :string
    field :price, :float
    timestamps()

    belongs_to :category, Category
  end

  @doc false
  def create_changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :price, :category_id])
    |> assoc_constraint(:category)
    |> validate_required([:name, :price])
    |> unique_constraint(:name)
    |> validate_number(:price, greater_than: 0)
    |> validate_inclusion(:category_id, category_ids())
  end

  @doc false
  def update_changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :price, :bought, :category_id])
    |> assoc_constraint(:category)
    |> unique_constraint(:name)
    |> validate_number(:price, greater_than: 0)
    |> validate_inclusion(:category_id, category_ids())
  end

  defp category_ids do
    (from c in Category, select: c.id) |> Repo.all
  end
end
