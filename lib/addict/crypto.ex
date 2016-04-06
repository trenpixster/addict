defmodule Addict.Crypto do
  def sign(plaintext, key \\ Addict.Configs.secret_key) do
    :crypto.hmac(:sha512, key, plaintext) |> Base.encode16
  end

  def verify(plaintext, signature, key \\ Addict.Configs.secret_key) do
    base_signature = sign(plaintext, key)
    do_verify(base_signature == signature)
  end

  defp do_verify(true) do
    {:ok, true}
  end

  defp do_verify(false) do
    {:error, [{:token, "Password reset token not valid."}]}
  end

  defp decode_key(key) do
    Base.decode64(key) |> do_decode_key
  end

  defp do_decode_key(:error) do
    {:error, ["Addict secret_key", "Addict.Configs.secret_key is invalid"]}
  end

  defp do_decode_key(key) do
    key
  end
end
