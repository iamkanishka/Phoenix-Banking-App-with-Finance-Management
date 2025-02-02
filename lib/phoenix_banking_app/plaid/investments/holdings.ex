defmodule PhoenixBankingApp.Plaid.Investments.Holdings do
  @moduledoc """
  Functions for Plaid `investments/holdings` endpoints.
  """

  alias PhoenixBankingApp.Plaid.Client.Request
  alias PhoenixBankingApp.Plaid.Client

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, securities: [], holdings: [], request_id: nil

  @type t :: %__MODULE__{
          accounts: [PhoenixBankingApp.Plaid.Accounts.Account.t()],
          item: PhoenixBankingApp.Plaid.Item.t(),
          securities: [PhoenixBankingApp.Plaid.Investments.Security.t()],
          holdings: [PhoenixBankingApp.Plaid.Investments.Holdings.Holding.t()],
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, PhoenixBankingApp.Plaid.Error.t() | any()} | no_return

  defmodule Holding do
    @moduledoc """
    Plaid Investments Holding data structure.
    """

    @derive Jason.Encoder
    defstruct account_id: nil,
              security_id: nil,
              institution_price: nil,
              institution_price_as_of: nil,
              institution_value: nil,
              cost_basis: nil,
              quantity: nil,
              iso_currency_code: nil,
              unofficial_currency_code: nil

    @type t :: %__MODULE__{
            account_id: String.t(),
            security_id: String.t(),
            institution_price: float,
            institution_price_as_of: String.t() | nil,
            institution_value: float,
            cost_basis: float | nil,
            quantity: float,
            iso_currency_code: String.t() | nil,
            unofficial_currency_code: String.t() | nil
          }
  end

  @doc """
  Gets user-authorized stock position data for investment-type Accounts

  Parameters
  ```
  %{
    access_token: "access-env-identifier",
    options: %{
      account_ids: ["BFEWTGFD"]
    }
  }
  ```
  """
  @spec get(params, config) :: {:ok, PhoenixBankingApp.Plaid.Investments.Holdings.t()} | error
  def get(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "investments/holdings/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_investments_holdings(&1))
  end

  defp map_investments_holdings(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %PhoenixBankingApp.Plaid.Investments.Holdings{
          accounts: [
            %PhoenixBankingApp.Plaid.Accounts.Account{
              balances: %PhoenixBankingApp.Plaid.Accounts.Account.Balance{}
            }
          ],
          securities: [%PhoenixBankingApp.Plaid.Investments.Security{}],
          holdings: [%PhoenixBankingApp.Plaid.Investments.Holdings.Holding{}],
          item: %PhoenixBankingApp.Plaid.Item{}
        }
      }
    )
  end
end
