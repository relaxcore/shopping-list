defmodule TestTaskWeb.ItemView do
  use TestTaskWeb, :view

  alias TestTask.Repo
  alias TestTaskWeb.{CategoryView, ItemView}

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    item = item |> Repo.preload(:category)
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      id:       item.id,
      name:     item.name,
      price:    item.price,
      bought:   item.bought,
      category: render_one(item.category, CategoryView, "category.json")
    }
  end
end
