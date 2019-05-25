defmodule TestTaskWeb.Router do
  use TestTaskWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TestTaskWeb do
    pipe_through :api
  end
end
