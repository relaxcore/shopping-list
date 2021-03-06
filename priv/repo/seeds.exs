alias TestTask.Repo
alias TestTask.ShopList.{Category, Item}

Repo.delete_all(Item)
Repo.delete_all(Category)

categories = [
  %Category{name: "Groceries"},
  %Category{name: "Beverages"},
  %Category{name: "Personal Care"}
]

Enum.each(categories, fn(data) ->
  Repo.insert! data
end)

############

beverages_id     = Repo.get_by!(Category, name: "Beverages").id
groceries_id     = Repo.get_by!(Category, name: "Groceries").id
personal_care_id = Repo.get_by!(Category, name: "Personal Care").id

items = [
  %Item{name: "Apple juice", price: 10.0, category_id: beverages_id},
  %Item{name: "Water", price: 0.5, category_id: beverages_id},
  %Item{name: "Barbecue sauce", price: 1.5, category_id: groceries_id},
  %Item{name: "Fruits", price: 5.0, category_id: groceries_id},
  %Item{name: "Olive oil", price: 15.0, category_id: groceries_id},
  %Item{name: "Toothbrush", price: 2.5, category_id: personal_care_id},
  %Item{name: "Deodorant", price: 3.5, category_id: personal_care_id},
  %Item{name: "Liquid soap", price: 4.0, category_id: personal_care_id},
  %Item{name: "Shampoo", price: 7.0, category_id: personal_care_id, bought: true},
  %Item{name: "Rice", price: 5.0, category_id: groceries_id, bought: true},
  %Item{name: "Coca-Cola", price: 2.5, category_id: beverages_id, bought: true},
  %Item{name: "Beer", price: 3.25, category_id: beverages_id, bought: true}
]

Enum.each(items, fn(data) ->
  Repo.insert! data
end)
