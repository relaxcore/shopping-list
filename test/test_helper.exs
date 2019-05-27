alias TestTask.Repo
alias TestTask.ShopList.{Category, Item}

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TestTask.Repo, {:shared, self()})
Repo.delete_all(Item)
Repo.delete_all(Category)

categories = [
  %Category{name: "Groceries"},
  %Category{name: "Personal Care"},
  %Category{name: "Beverages"}
]

[{:ok, category1}, {:ok, category2}, {:ok, category3}] = Enum.map(categories, &Repo.insert(&1))

items = [
  %Item{name: "Item1", price: 10.0, category_id: category1.id, bought: true},
  %Item{name: "Item2", price: 5.0,  category_id: category1.id, bought: false},
  %Item{name: "Item3", price: 1.0,  category_id: category2.id, bought: true},
  %Item{name: "Item4", price: 6.5,  category_id: category2.id, bought: false},
  %Item{name: "Item5", price: 55.0, category_id: category3.id, bought: true},
  %Item{name: "Item6", price: 0.15, category_id: category3.id, bought: false}
]

Enum.map(items, &Repo.insert(&1))