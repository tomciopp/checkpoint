# Checkpoint

**Checkpoint is a minimal authorization library based off of Ruby's [pundit](https://github.com/varvet/pundit) library**

## Usage

Add the following to `lib/example_web` or to the beginning of your controller
```elixir
defmodule ExampleWeb.PageController do
  use ExampleWeb, :controller

  plug(Checkpoint)

  def index(conn, _params) do
    render conn, "index.html"
  end
end

def controller do
  quote do
    use Phoenix.Controller, namespace: CheckpointWeb
    import Plug.Conn
    import ExampleWeb.Router.Helpers
    import ExampleWeb.Gettext

    plug(Checkpoint)
  end
end
```

**Note: This library will not work if you add the plug to your router's pipeline as it depends on knowing the controller module**

This plug expects a corresponding policy module that has the same naming structure as the controller. It will dynamically call a method in the policy that corresponds to the action called in the controller with a `?` appended. An example is provided below for clarity. e.g. ExampleWeb.PageController#index => ExampleWeb.PagePolicy#index?

```elixir
defmodule ExampleWeb.PagePolicy do
  # receives conn, assigns, and params
  def index?(conn, %{current_user: user}, _params) do
    if user.admin do
      {:ok, conn}
    else
      {:error, %{
        path: "/login",
        message: "You must be an admin in order to access this page"
      }}
    end
  end
end
```

You can return either an {:ok, conn} tuple to signify that the request is authorized or an {:error, map} tuple to signify that authorization has failed.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `checkpoint` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:checkpoint, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/checkpoint](https://hexdocs.pm/checkpoint).

