defmodule PhoenixBankingApp.Utils.SessionManager do
  @moduledoc """
  A simple session manager using ETS for storing session tokens with expiration.
  """

  @table_name :session_store
  # 1 hour in seconds
  @default_max_age 3600 * 24

  @doc """
  Initializes the ETS table for storing session data.
  """
  def init do
    :ets.new(@table_name, [:named_table, :public, :set, {:read_concurrency, true}])
  end

  @doc """
  Stores a session token with a given `key` and optional `max_age`.
  """
  def put_session(key, token) when is_binary(key) and is_binary(token) do
    :ets.insert(@table_name, {key, token})
    :ok
  end

  @spec get_session(binary()) :: {:error, :expired | :not_found} | {:ok, any()}
  @doc """
  Retrieves a session token by its `key`, ensuring it is still valid.
  """
  def get_session(key) when is_binary(key) do
    case :ets.lookup(@table_name, key) do
      [{^key, token}] ->
        # Calculate the expiration time
        expiration_time = DateTime.add(DateTime.utc_now(), @default_max_age, :second)

        # Check if the session is still valid
        if DateTime.compare(expiration_time, DateTime.utc_now()) == :gt do
          {:ok, token}
        else
          delete_session(key)
          {:error, :expired}
        end

      [] ->
        {:error, :not_found}
    end
  end

  @doc """
  Deletes a session by its `key`.
  """
  def delete_session(key) when is_binary(key) do
    :ets.delete(@table_name, key)
    :ok
  end

  @doc """
  Checks if a session token is valid without retrieving it.
  """
  def valid_session?(key) when is_binary(key) do
    case :ets.lookup(@table_name, key) do
      [{^key, _token, expires_at}] ->
        System.system_time(:second) <= expires_at

      [] ->
        false
    end
  end

  @doc """
  Cleans up expired sessions from the ETS table.
  """
  def cleanup_expired_sessions do
    current_time = System.system_time(:second)

    :ets.tab2list(@table_name)
    |> Enum.each(fn {key, _token, expires_at} ->
      if expires_at < current_time do
        delete_session(key)
      end
    end)

    :ok
  end

  def to_max_age(iso_timestamp) do
    with {:ok, future_time, _} <- DateTime.from_iso8601(iso_timestamp),
         current_time = DateTime.utc_now(),
         seconds_diff when seconds_diff > 0 <- DateTime.diff(future_time, current_time, :second) do
      seconds_diff
    else
      # Return 0 if the timestamp is invalid or expired
      _ -> 0
    end
  end

  def calculate_max_age(iso_timestamp) do
    case DateTime.from_iso8601(iso_timestamp) do
      {:ok, datetime, _offset} ->
        current_time = DateTime.utc_now()
        seconds_diff = DateTime.diff(datetime, current_time, :second)

        if seconds_diff > 0 do
          {:ok, seconds_diff}
        else
          {:error, :expired_timestamp}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  # # Example usage:
  # iso_timestamp = "2026-01-04T11:10:40.672+00:00"
  # case calculate_max_age(iso_timestamp) do
  #   {:ok, max_age} -> IO.puts("Max age: #{max_age} seconds")
  #   {:error, :expired_timestamp} -> IO.puts("The timestamp has already expired.")
  #   {:error, reason} -> IO.puts("Invalid timestamp: #{inspect(reason)}")
  # end
end
