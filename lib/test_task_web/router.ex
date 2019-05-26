defmodule TestTaskWeb.Router do
  use TestTaskWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TestTaskWeb do
    pipe_through :api
    scope "/v1" do
      resources "/items", ItemController, except: [:new, :edit]
      resources "/categories", CategoryController, only: [:index]
    end
  end
end
