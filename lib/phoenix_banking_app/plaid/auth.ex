defmodule PhoenixBankingApp.Plaid.Auth do
  @moduledoc """
  Functions for Plaid `auth` endpoint.
  """

  alias PhoenixBankingApp.Plaid.Client.Request
  alias PhoenixBankingApp.Plaid.Client

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, numbers: [], request_id: nil

  @type t :: %__MODULE__{
          accounts: [PhoenixBankingApp.Plaid.Accounts.Account.t()],
          item: PhoenixBankingApp.Plaid.Item.t(),
          numbers: %PhoenixBankingApp.Plaid.Auth.Numbers{
            ach: [PhoenixBankingApp.Plaid.Auth.Numbers.ACH.t()],
            eft: [PhoenixBankingApp.Plaid.Auth.Numbers.EFT.t()],
            international: [PhoenixBankingApp.Plaid.Auth.Numbers.International.t()],
            bacs: [PhoenixBankingApp.Plaid.Auth.Numbers.BACS.t()]
          },
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, PhoenixBankingApp.Plaid.Error.t() | any()} | no_return

  defmodule Numbers do
    @moduledoc """
    Plaid Account Number data structure.

    There are 2 types of numbers that Plaid supports: ACH and EFT, the latter being specific to Canadian banking.
    """

    @derive Jason.Encoder
    defstruct ach: [], eft: [], international: [], bacs: []

    @type t :: %__MODULE__{
            ach: [PhoenixBankingApp.Plaid.Auth.Numbers.ACH.t()],
            eft: [PhoenixBankingApp.Plaid.Auth.Numbers.EFT.t()],
            international: [PhoenixBankingApp.Plaid.Auth.Numbers.International.t()],
            bacs: [PhoenixBankingApp.Plaid.Auth.Numbers.BACS.t()]
          }

    defmodule ACH do
      @moduledoc """
      Plaid Account Number ACH data structure.
      """

      @derive Jason.Encoder
      defstruct account: nil, account_id: nil, routing: nil, wire_routing: nil

      @type t :: %__MODULE__{
              account: String.t(),
              account_id: String.t(),
              routing: String.t(),
              wire_routing: String.t()
            }
    end

    defmodule EFT do
      @moduledoc """
      Plaid Account Number EFT data structure
      """

      @derive Jason.Encoder
      defstruct account: nil, account_id: nil, institution: nil, branch: nil

      @type t :: %__MODULE__{
              account: String.t(),
              account_id: String.t(),
              institution: String.t(),
              branch: String.t()
            }
    end

    defmodule International do
      @moduledoc """
      Plaid Account Number Institution data structure.
      """

      @derive Jason.Encoder
      defstruct account_id: nil, bic: nil, iban: nil

      @type t :: %__MODULE__{
              account_id: String.t(),
              bic: String.t(),
              iban: String.t()
            }
    end

    defmodule BACS do
      @moduledoc """
      Plaid Account Number BACS data structure.
      """

      @derive Jason.Encoder
      defstruct account: nil, account_id: nil, sort_code: nil

      @type t :: %__MODULE__{
              account: String.t(),
              account_id: String.t(),
              sort_code: String.t()
            }
    end
  end

  @doc """
  Gets auth data associated with an Item.

  Parameters
  ```
  %{
    access_token: "access-env-identifier",
    options: %{
      account_ids: [
      ]
    }
  }
  ```
  """
  @spec get(params, config) :: {:ok, PhoenixBankingApp.Plaid.Auth.t()} | error
  def get(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "auth/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_auth(&1))
  end

  defp map_auth(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %PhoenixBankingApp.Plaid.Auth{
          numbers: %PhoenixBankingApp.Plaid.Auth.Numbers{
            ach: [%PhoenixBankingApp.Plaid.Auth.Numbers.ACH{}],
            eft: [%PhoenixBankingApp.Plaid.Auth.Numbers.EFT{}],
            international: [%PhoenixBankingApp.Plaid.Auth.Numbers.International{}],
            bacs: [%PhoenixBankingApp.Plaid.Auth.Numbers.BACS{}]
          },
          item: %PhoenixBankingApp.Plaid.Item{},
          accounts: [
            %PhoenixBankingApp.Plaid.Accounts.Account{
              balances: %PhoenixBankingApp.Plaid.Accounts.Account.Balance{}
            }
          ]
        }
      }
    )
  end
end
