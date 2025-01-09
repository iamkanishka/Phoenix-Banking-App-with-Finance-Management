defmodule PhoenixBankingApp.Services.TransactionService do
  alias Appwrite.Utils.Query
  alias PhoenixBankingApp.Constants.EnvKeysFetcher

  alias Appwrite.Services.Database

  def get_transactions_by_bank_id(bank_id) do
    try do
      {:ok, sender_transactions} =
        Database.list_documents(
          EnvKeysFetcher.get_appwrite_database_id(),
          EnvKeysFetcher.get_transaction_collection_id(),
          [Query.equal("sender_bank_id", [bank_id])]
        )

      {:ok, reciever_transactions} =
        Database.list_documents(
          EnvKeysFetcher.get_appwrite_database_id(),
          EnvKeysFetcher.get_transaction_collection_id(),
          [Query.equal("reciever_bank_id", [bank_id])]
        )

      transaction = %{
        total: length(sender_transactions["documents"]) + length(reciever_transactions["documents"]),
        documents: sender_transactions["documents"] ++ reciever_transactions["documents"]
      }

      {:ok, transaction}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  def create_trasnsaction(transaction) do
    try do
      merged_transaction =
        Map.merge(
          %{
            channel: "online",
            category: "Transfer"
          },
          transaction
        )

      transaction_doc =
        Database.create_document(
          EnvKeysFetcher.get_appwrite_database_id(),
          EnvKeysFetcher.get_transaction_collection_id(),
          nil,
          merged_transaction,
          nil
        )

      {:ok, transaction_doc}
    catch
      {:error, error} ->
        {:error, error}
    end
  end
end
