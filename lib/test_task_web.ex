defmodule TestTaskWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: TestTaskWeb

      import Plug.Conn
      import TestTaskWeb.Gettext
      alias TestTaskWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/test_task_web/templates",
        namespace: TestTaskWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import TestTaskWeb.ErrorHelpers
      import TestTaskWeb.Gettext

      alias TestTaskWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
