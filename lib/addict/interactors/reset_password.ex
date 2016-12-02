defmodule Addict.Interactors.ResetPassword do
  alias Addict.Interactors.{GetUserById, UpdateUserPassword, ValidatePassword}
  require Logger

  @doc """
  Executes the password reset flow: parameters validation, password hash generation, user updating.

  Returns `{:ok, user}` or `{:error, [errors]}`
  """
  def call(params) do
    token     = params["token"]
    password  = params["password"]
    signature = params["signature"]

    with {:ok} <- validate_params(token, password, signature),
         {:ok, true} <- Addict.Crypto.verify(token, signature),
         {:ok, generation_time, user_id} <- parse_token(token),
         {:ok} <- validate_generation_time(generation_time),
         {:ok, _} <- validate_password(password),
         {:ok, user} <- GetUserById.call(user_id),
         {:ok, _} <- UpdateUserPassword.call(user, password),
     do: {:ok, user}
  end

  defp validate_params(token, password, signature) do
    if token == nil || password == nil || signature == nil do
      Logger.debug("Invalid params for password reset")
      Logger.debug("token: #{token}")
      Logger.debug("password: #{password}")
      Logger.debug("signature: #{signature}")
      {:error, [{:params, "Invalid params"}]}
    else
      {:ok}
    end
  end

  defp parse_token(token) do
    [generation_time, user_id] = Base.decode16!(token) |> String.split(",")
    {:ok, String.to_integer(generation_time), String.to_integer(user_id)}
  end

  defp validate_generation_time(generation_time) do
    time_to_expiry = if Addict.Configs.password_reset_token_time_to_expiry != nil do
      Addict.Configs.password_reset_token_time_to_expiry
    else
      86_400
    end
    do_validate_generation_time(:erlang.system_time(:seconds) - generation_time <= time_to_expiry)
  end

  defp do_validate_generation_time(true) do
    {:ok}
  end

  defp do_validate_generation_time(false) do
    {:error, [{:token, "Password reset token not valid."}]}
  end

  defp validate_password(password, password_strategies \\ Addict.Configs.password_strategies) do
    %Addict.PasswordUser{}
    |> Ecto.Changeset.cast(%{password: password}, ~w(password), [])
    |> ValidatePassword.call(password_strategies)
  end

end
