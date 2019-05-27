defmodule ItemFilters do
  import Ecto.Query
  import Ecto.Type

  def call(query, params) do
    args = fetch_filters(params)

    Enum.reduce(args, query, fn {k, v}, query ->
      case k do
        "bought"   -> already_bought(query, v)
        "category" -> with_category(query, v)
        _          -> query
      end
    end)
  end

  defp already_bought(query, bought) do
    unless cast(:boolean, bought) == :error  do
      query
      |> where([item], item.bought == ^bought)
    else
      query
    end
  end

  defp with_category(query, category_name) do
    query
    |> join(:inner, [item], c in assoc(item, :category))
    |> where([item, category], category.name == ^category_name)
  end

  defp fetch_filters(params) do
    Map.take(params, ["filter"]) |> Map.get("filter") || %{}
  end
end
