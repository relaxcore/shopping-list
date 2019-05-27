defmodule TestTaskWeb.ItemControllerTest do
  use TestTaskWeb.ConnCase
  import Ecto.Query

  alias TestTask.Repo
  alias TestTask.ShopList.{Category, Item}

  @url "api/v1/items"
  @items Repo.all(Item)

  describe "index" do
    test "return correct data structure", %{conn: conn} do
      conn     = get(conn, @url)
      response = json_response(conn, 200)

      assert response |> Map.has_key?("data")
      assert response |> Map.get("data") |> Enum.count == 6
    end
    
    test "return correct items", %{conn: conn} do
      conn         = get(conn, @url)
      response     = json_response(conn, 200)
      response_ids = response |> Map.get("data") |> Enum.map(fn x -> x["id"] end)
      items_ids    = @items |> Enum.map(fn x -> x.id end)

      assert response_ids == items_ids
    end
  
    # SORTING
    @max_price @items |> Enum.map(fn x -> x.price end) |> Enum.max
    @min_price @items |> Enum.map(fn x -> x.price end) |> Enum.min
  
    test "return ASC sorted by price collection", %{conn: conn} do
      data_response = conn
        |> put_req_header("content-type", "application/json")
        |> get(@url <> "?sort[price]=asc")
        |> json_response(200)
        |> Map.get("data")

      response_first_item_price = data_response |> Enum.at(0)  |> Map.get("price")
      response_last_item_price  = data_response |> Enum.at(-1) |> Map.get("price")

      assert response_first_item_price == @min_price
      assert response_last_item_price  == @max_price
    end

    test "return DESC sorted by price collection", %{conn: conn} do
      data_response = conn
        |> put_req_header("content-type", "application/json")
        |> get(@url <> "?sort[price]=desc")
        |> json_response(200)
        |> Map.get("data")

      response_first_item_price = data_response |> Enum.at(0)  |> Map.get("price")
      response_last_item_price  = data_response |> Enum.at(-1) |> Map.get("price")

      assert response_first_item_price == @max_price
      assert response_last_item_price  == @min_price
    end

    # FILTERS
    test "return only bought items", %{conn: conn} do
      response_ids = conn
        |> put_req_header("content-type", "application/json")
        |> get(@url <> "?filter[bought]=true")
        |> json_response(200)
        |> Map.get("data")
        |> Enum.map(fn x -> x["id"] end)
      bought_items_ids = where(Item, bought: true) |> Repo.all |> Enum.map(fn x -> x.id end)

      assert response_ids == bought_items_ids
    end

    test "return only not bought items", %{conn: conn} do
      response_ids = conn
        |> put_req_header("content-type", "application/json")
        |> get(@url <> "?filter[bought]=false")
        |> json_response(200)
        |> Map.get("data")
        |> Enum.map(fn x -> x["id"] end)
      not_bought_items_ids = where(Item, bought: false) |> Repo.all |> Enum.map(fn x -> x.id end)

      assert response_ids == not_bought_items_ids
    end

    test "return items with specific category", %{conn: conn} do
      category_id   = Enum.random(Repo.all(Category)).id
      category_name = Repo.get(Category, category_id).name
      response_ids  = conn
        |> put_req_header("content-type", "application/json")
        |> get(@url <> "?filter[category]=#{category_name}")
        |> json_response(200)
        |> Map.get("data")
        |> Enum.map(fn x -> x["id"] end)

      category_items_ids = where(Item, category_id: ^category_id) |> Repo.all |> Enum.map(fn x -> x.id end)

      assert response_ids == category_items_ids
    end
  end

  describe "show" do
    test "return single item", %{conn: conn} do
      item_id  = Enum.random(Repo.all(Item)).id
      response = conn
        |> get(@url <> "/#{item_id}")
        |> json_response(200)
        |> Map.get("data")

      assert is_map response
      assert response["id"] == item_id
    end

    test "return error if item not found", %{conn: conn} do
      response = conn
        |> get(@url <> "/123")
        |> json_response(404)

      assert response |> Map.has_key?("errors")
      assert response |> get_in(["errors", "detail"]) == "Not Found"
    end
  end

  describe "create" do
    test "create item with valid params", %{conn: conn} do
      name        = "create test"
      price       = 100.0
      category_id = Enum.random(Repo.all(Category)).id

      valid_params = "?name=#{name}&price=#{price}&category_id=#{category_id}"

      response = conn
        |> post(@url <> valid_params)
        |> json_response(201)
        |> Map.get("data")

      created_item_id = response["id"]

      assert response["name"]           == name
      assert response["price"]          == price
      assert response["category"]["id"] == category_id    
      assert !!Repo.get(Item, created_item_id)
    end

    test "return error with invalid params", %{conn: conn} do
      invalid_params = "?name=test&price=test&category_id=test"
      response = conn
        |> post(@url <> invalid_params)
        |> json_response(422)

      assert response |> Map.has_key?("errors")
      assert response["errors"]["category_id"] == ["is invalid"]
      assert response["errors"]["price"]       == ["is invalid"]
    end

    test "return error with blank params", %{conn: conn} do
      response = conn
        |> post(@url)
        |> json_response(422)

      assert response |> Map.has_key?("errors")
      assert response["errors"]["name"]  == ["can't be blank"]
      assert response["errors"]["price"] == ["can't be blank"]
    end
  end

  describe "update" do
    test "update item with valid params", %{conn: conn} do
      item_id     = Enum.random(Repo.all(Item)).id
      name        = "update test"
      price       = 200.0
      category_id = Enum.random(Repo.all(Category)).id

      valid_params = "/#{item_id}?name=#{name}&price=#{price}&category_id=#{category_id}"

      response = conn
        |> put(@url <> valid_params)
        |> json_response(200)
        |> Map.get("data")

      assert response["id"]             == item_id
      assert response["name"]           == name
      assert response["price"]          == price
      assert response["category"]["id"] == category_id

      assert from(i in Item, where: [id: ^item_id, name: ^name, price: ^price, category_id: ^category_id]) 
             |> Repo.all
             |> Enum.any?
    end

    test "return error with invalid params", %{conn: conn} do
      item_id        = Enum.random(Repo.all(Item)).id
      invalid_params = "/#{item_id}?name=test&price=test&category_id=test"

      response = conn
        |> put(@url <> invalid_params)
        |> json_response(422)

      assert response |> Map.has_key?("errors")
      assert response["errors"]["category_id"] == ["is invalid"]
      assert response["errors"]["price"]       == ["is invalid"]
    end

    test "return error if item not found", %{conn: conn} do
      response = conn
        |> put(@url <> "/123")
        |> json_response(404)

      assert response |> Map.has_key?("errors")
      assert response |> get_in(["errors", "detail"]) == "Not Found"
    end
  end

  describe "delete" do
    test "delete item if ID valid", %{conn: conn} do
      item_id = Enum.random(Repo.all(Item)).id

      conn
        |> get(@url <> "/#{item_id}")
        |> json_response(200)
    end

    test "return error if item not found", %{conn: conn} do
      response = conn
        |> delete(@url <> "/123")
        |> json_response(404)

      assert response |> Map.has_key?("errors")
      assert response |> get_in(["errors", "detail"]) == "Not Found"
    end
  end
end
