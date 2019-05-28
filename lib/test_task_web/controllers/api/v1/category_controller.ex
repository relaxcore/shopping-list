defmodule TestTaskWeb.Api.V1.CategoryController do
  use TestTaskWeb, :controller

  alias TestTask.ShopList

  action_fallback TestTaskWeb.FallbackController

  def index(conn, _params) do
    render(conn, "index.json", categories: ShopList.list_categories)
  end
end
