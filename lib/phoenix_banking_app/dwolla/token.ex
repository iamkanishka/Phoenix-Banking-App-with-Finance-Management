defmodule PhoenixBankingApp.Dwolla.Token do
  @moduledoc """
  Functions for Dwolla OAuth 2 endpoint.
  """

alias PhoenixBankingApp.Dwolla.Dwolla
alias PhoenixBankingApp.Dwolla.Utils

  defstruct access_token: nil, expires_in: nil, token_type: nil

  @type t :: %__MODULE__{access_token: String.t,
                         expires_in: integer,
                         token_type: String.t}
  @type cred :: %{required(atom) => String.t}
  @type error :: HTTPoison.Error.t | PhoenixBankingApp.Dwolla.Errors.t

  @doc """
  Gets an access token from application credentials.
  """
  @spec get(cred | nil) :: {:ok, PhoenixBankingApp.Dwolla.Token.t} | {:error, error}
  def get(cred \\ Dwolla.get_cred()) do
    params = %{grant_type: "client_credentials"}
    Dwolla.make_oauth_token_request(params, cred)
    |> Utils.handle_resp(:token)
  end

end
