defmodule TestTaskWeb.ItemView do
  use TestTaskWeb, :view

  alias TestTaskWeb.{ItemView, CategoryView}
  alias TestTask.Repo

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    item = item |> Repo.preload(:category)

    %{
      id:       item.id,
      name:     item.name,
      price:    item.price,
      bougth:   item.bougth,
      category: render_one(item.category, CategoryView, "category.json")
    }
  end
end
