defmodule TestTaskWeb.ItemController do
  use TestTaskWeb, :controller

  alias TestTask.ShopList
  alias TestTask.ShopList.Item

  action_fallback TestTaskWeb.FallbackController

  def index(conn, params) do
    items = ShopList.list_items(params)

    render(conn, "index.json", items: items)
  end

  def show(conn, %{"id" => id}) do
    with %Item{} = item <- ShopList.get_item(id) do
      render(conn, "show.json", item: item)
    end
  end

  def create(conn, params) do
    with {:ok, %Item{} = item} <- ShopList.create_item(params) do
      conn
      |> put_status(:created)
      |> render("show.json", item: item)
    end
  end

  def update(conn, item_params) do
    id = item_params |> get_in(["id"])

    with %Item{} = item <- ShopList.get_item(id) do
      ShopList.update_item(item, item_params)
      conn
      |> put_status(:ok)
      |> render("show.json", item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    with %Item{} = item <- ShopList.get_item(id) do
      ShopList.delete_item(item)
      send_resp(conn, :ok, "")
    end
  end
end
