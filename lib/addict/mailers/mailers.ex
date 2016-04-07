defmodule Addict.Mailers do
  @moduledoc """
  Sends e-mail using the configured mail service on `Addict.Configs.mail_service`
  """
  require Logger

  def send_email(to, from, subject, html_body, mail_service \\ Addict.Configs.mail_service) do
    do_send_email(to, from, subject, html_body, mail_service)
  end

  defp do_send_email(_, _, _, _, nil) do
    Logger.debug "Not sending e-mail: No registered mail service."
    {:ok, nil}
  end

  defp do_send_email(to, from, subject, html_body, mail_service) do
    mail_service = to_string(mail_service) |> Mix.Utils.camelize
    mailer = Module.concat Addict.Mailers, mail_service
    mailer.send_email(to, from, subject, html_body)
  end

end
