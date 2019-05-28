defmodule TestTaskWeb.ItemController do
  use TestTaskWeb, :controller

  alias TestTask.Repo
  alias TestTask.ShopList.Item

  def index(conn, _params) do
    items = Repo.all(Item) |> Repo.preload(:category)
    render(conn, "index.html", items: items)
  end
end
