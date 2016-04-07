defmodule Addict.Interactors.SendResetPasswordEmail do
  alias Addict.Interactors.{GetUserByEmail, GeneratePasswordResetLink}
  require Logger

  @doc """
  Executes the password recovery flow: verifies if the user exists and sends the e-mail with the reset link

  Either returns `{:ok, user}` or `{:ok, nil}`. `{:ok, nil}` is returned when e-mail is not found to avoid user enumeration.
  """
  def call(email, configs \\ Addict.Configs) do
    {result, user} = GetUserByEmail.call(email)

    case result do
      :error -> return_false_positive(email)
      :ok    -> with  {:ok, path} <- GeneratePasswordResetLink.call(user.id, configs.secret_key),
                      {:ok, _} <- Addict.Mailers.MailSender.send_reset_token(email, path),
                  do: {:ok, user}

    end
  end

  defp return_false_positive(email) do
    Logger.debug("Recover Password: E-mail not found: #{email}.")
    {:ok, nil}
  end

end
