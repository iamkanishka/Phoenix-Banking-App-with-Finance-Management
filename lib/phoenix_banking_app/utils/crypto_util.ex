defmodule PhoenixBankingApp.Utils.CryptoUtil do
  @moduledoc """
  Utility module for encrypting and decrypting data.
  """

  @key_size 32
  # 256-bit encryption key
  @secret_key :crypto.strong_rand_bytes(@key_size)
  # Separate signing key
  @signing_key :crypto.strong_rand_bytes(@key_size)

  # @key_size 32

  # # Derive encryption and signing keys from your secret_key_base
  # @secret_key :crypto.hash(:sha256, EnvKeysFetcher.get_secret_key())
  # @signing_key :crypto.hash(:sha256, "signing_" <> EnvKeysFetcher.get_secret_key())

  @doc """
  Encrypts the given data using Plug.Crypto.MessageEncryptor.
  """
  def encrypt(data) when is_binary(data) do
    Plug.Crypto.encrypt(data, @secret_key, @signing_key, [])
  end

  @doc """
  Decrypts the given encrypted data using Plug.Crypto.MessageEncryptor.
  """
  def decrypt(encrypted_data) when is_binary(encrypted_data) do
    Plug.Crypto.decrypt(encrypted_data, @secret_key, @signing_key, [])
  end
end

# Example Usage
# encrypted_data = PhoenixBankingApp.Utils.CryptoUtil.encrypt("Hello, Elixir!")
# {:ok, plaintext} = PhoenixBankingApp.Utils.CryptoUtil.decrypt(encrypted_data)
# IO.inspect(plaintext) # "Hello, Elixir!"
