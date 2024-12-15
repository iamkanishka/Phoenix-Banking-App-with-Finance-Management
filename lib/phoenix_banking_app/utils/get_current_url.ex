defmodule PhoenixBankingApp.Utils.GetCurrentUrl do
  def get_url() do
    case :ets.lookup(:local_storage, :current_url) do
      [{:current_url, value}] -> value
      [] -> "No URL available"
    end
  end

end
