defmodule Checkpoint do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case apply(policy_for(conn), action(conn), [conn, conn.assigns, conn.params]) do
      {:ok, conn} -> conn
      {:error, map} -> unauthorized(conn, map)
    end
  end

  defp policy_for(conn) do
    conn
    |> controller_module()
    |> Atom.to_string()
    |> String.replace_trailing("Controller", "Policy")
    |> String.to_existing_atom()
  end

  defp action(conn), do: String.to_existing_atom("#{action_name(conn)}?")

  defp unauthorized(%{private: %{phoenix_format: "json"}} = conn, map) do
    conn
    |> put_status(401)
    |> json(Map.get(map, :response, error_json()))
    |> halt()
  end

  defp unauthorized(%{private: %{phoenix_format: "html"}} = conn, map) do
    conn
    |> put_flash(:error, Map.get(map, :message, "Unauthorized"))
    |> redirect(to: Map.get(map, :path, "/"))
    |> halt()
  end

  defp error_json do
    %{
      error: %{
        status: "401",
        title: "Unauthorized",
        detail: "You are not authorized to perform that action"
      }
    }
  end
end
