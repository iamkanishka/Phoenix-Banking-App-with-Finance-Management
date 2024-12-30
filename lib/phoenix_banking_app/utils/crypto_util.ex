defmodule PhoenixBankingApp.Utils.CryptoUtil do
  @secret_key_base :crypto.strong_rand_bytes(64) # Typically your Phoenix app's secret_key_base


  # Encrypt data
  def encrypt(data) do
    Plug.Crypto.MessageEncryptor.encrypt(data, @secret_key_base, @secret_key_base, [])
  end

  # Decrypt data
  def decrypt(encrypted_data) do
    Plug.Crypto.MessageEncryptor.decrypt(encrypted_data, @secret_key_base,  @secret_key_base, [])
  end
end

# Usage
# encrypted_data = CryptoUtil.encrypt("Hello, Elixir!")
# {:ok, plaintext} = CryptoUtil.decrypt(encrypted_data)
# IO.inspect(plaintext) # "Hello, Elixir!"
