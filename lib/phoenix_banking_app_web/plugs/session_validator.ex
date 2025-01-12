defmodule PhoenixBankingAppWeb.SessionValidator do
  @doc """
  Plug to validate session using the `key` from query parameters.
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

      {:error, reason} ->
        # Halt the connection and respond with an error
        conn
        |> put_status(:unauthorized)
        |> json(%{error: to_string(reason)})
        |> halt()
    end
  end

  defp validate_session(nil), do: {:error, :missing_key}

  defp validate_session(key) when is_binary(key) do
    if MyApp.Session.valid_session?(key) do
      :ok
    else
      {:error, :invalid_session}
    end
  end
end
