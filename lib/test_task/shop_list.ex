defmodule TestTask.ShopList do
  @moduledoc """
  The ShopList context.
  """

  import Ecto.Query, warn: false

  alias TestTask.Repo
  alias TestTask.ShopList.{Category, Item}

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  ########################################

  @doc """
  Returns the filtered list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items(params) do
    Item
    |> ItemFilters.call(params)
    |> ItemSorting.call(params)
    |> Repo.all
    |> Repo.preload(:category)
  end

  @doc """
  Gets a single item.

  Return {:error, :not_found} if the Item does not exist.

  ## Examples

      iex> get_item(123)
      %Item{}

      iex> get_item(456)
      {:error, :not_found}

  """
  def get_item(id) do
    case Repo.get(Item, id) do
      %Item{} = item -> item
      nil -> {:error, :not_found}
    end
  rescue
    Ecto.Query.CastError -> {:error, :not_found} # need for UUID cast bug
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end
end
