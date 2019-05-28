defmodule TestTaskWeb.Router do
  use TestTaskWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestTaskWeb do
    pipe_through :browser

    get "/", ItemController, :index
  end

  scope "/api", TestTaskWeb do
    pipe_through :api
    scope "/v1" do
      resources "/items", Api.V1.ItemController, except: [:new, :edit]
      resources "/categories", Api.V1.CategoryController, only: [:index]
    end
  end
end
