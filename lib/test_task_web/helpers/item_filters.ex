defmodule ItemFilters do
  import Ecto.Query
  import Ecto.Type

  def filter(query, params) do
    args = fetch_filters(params)

    Enum.reduce(args, query, fn {k, v}, query ->
      case k do
        "bougth"   -> already_bougth(query, v)
        "category" -> with_category(query, v)
        _          -> query
      end
    end)
  end

  defp already_bougth(query, bougth) do
    unless cast(:boolean, bougth) == :error  do
      query
      |> where([item], item.bougth == ^bougth)
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
