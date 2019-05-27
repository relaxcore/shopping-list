defmodule ItemSorting do
  import Ecto.Query

  alias String

  @sort_keys ["name", "price"]

  def call(query, params) do
    Enum.reduce(sort_params(params), query, fn {k, v}, query ->
      if v in [:asc, :desc] do
        case k do
          :name  -> query |> order_by({^v, ^k})
          :price -> query |> order_by({^v, ^k})
          _      -> query
        end
      else
        query
      end
    end)
  end

  def sort_params(params) do
    raw_sort_params = Map.get(params, "sort")

    if raw_sort_params do
      raw_sort_params
      |> Map.take(@sort_keys)
      |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_atom(v)} end)
    else
      %{}
    end
  end
end
