defmodule PhoenixBankingApp.Constants.EnvKeysFetcher do
  def get_appwrite_database_id() do
    case Application.get_env(get_app_name(), :appwrite_database_id) do
      nil ->
        nil

      database_id ->
        database_id
    end
  end

  def get_user_collection_id() do
    case Application.get_env(get_app_name(), :appwrite_user_collection_id) do
      nil ->
        nil

      appwrite_user_collection_id ->
        appwrite_user_collection_id
    end
  end

  def get_bank_collection_id() do
    case Application.get_env(get_app_name(), :appwrite_bank_collection_id) do
      nil ->
        nil

      appwrite_bank_collection_id ->
        appwrite_bank_collection_id
    end
  end


  def get_transaction_collection_id() do
    case Application.get_env(get_app_name(), :appwrite_transaction_collection_id) do
      nil ->
        nil

      appwrite_bank_collection_id ->
        appwrite_bank_collection_id
    end
  end


  def get_secret_key() do
    case Application.get_env(get_app_name(), :secret_key_base) do
      nil ->
        nil

      database_id ->
        database_id
    end
  end



  defp get_app_name do
    Mix.Project.config()[:app]
  end
end
