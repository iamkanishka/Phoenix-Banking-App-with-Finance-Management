defmodule PhoenixBankingAppWeb.SessionValidator do
  alias PhoenixBankingApp.Utils.SessionManager
  import Plug.Conn
  import Phoenix.Controller

  @doc """
  Plug to validate session using the `key` from query parameters.
  Redirects to `/auth/sign-in` if the session is invalid or missing.
  """
  def init(default), do: default

  def call(conn, _opts) do
    # Get the `key` from query parameters
    key = conn.params["key"]

    # Check if the session is valid
    case validate_session(key) do
      :ok ->
        # Pass the connection forward if the session is valid
        conn

      {:error, _reason} ->
        # Redirect to the sign-in page if the session is invalid
        conn
        |> redirect(to: "/auth/sign-in")
        |> halt()
    end
  end

  defp validate_session(nil), do: {:error, :missing_key}

  defp validate_session(key) when is_binary(key) do
    if SessionManager.valid_session?(key) do
      :ok
    else
      {:error, :invalid_session}
    end
  end
end
