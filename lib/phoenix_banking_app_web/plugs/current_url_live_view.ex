defmodule PhoenixBankingAppWeb.Plugs.CurrentUrlLiveView do
  import Plug.Conn

  def init(default), do: default

  def call(conn,  _opts) do
    current_url = current_url(conn)
    IO.inspect(current_url, label: "current_urlsadcsad")
    table_name = :local_storage

    if ets_table_exists?(table_name) do
      :ets.insert(table_name, {:current_url, current_url})
    else
      :ets.new(table_name, [:named_table, :public])
      :ets.insert(table_name, {:current_url, current_url})
    end
     assign(conn, :current_url, current_url)
  end

  # Helper function to construct the current URL
  defp current_url(conn) do
    conn.req_headers
    |> Enum.find(fn {key, _value} -> key == "referer" end)
    |> case do
      {"referer", value} -> value
      # If the "referer" header is not found
      nil -> ""
    end
  end

  def ets_table_exists?(table_name) do
    case :ets.info(table_name) do
      :undefined -> false
      _info -> true
    end
  end
end
