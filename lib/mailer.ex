defmodule Addict.MailgunMailer do
  require Logger
  use Mailgun.Client, domain: Application.get_env(:addict, :mailgun_domain),
                      key: Application.get_env(:addict, :mailgun_key)

  def send_email_to_user(email, from, subject, html_body) do
    result = send_email to: email,
                 from: from,
                 subject: subject,
                 html: html_body

    case result do
      {:error, status, json_body} -> handle_error(email, status, json_body)
      _ -> {:ok, result}
    end
  end

  defp handle_error(email, status, json_body) do
    Logger.debug "Unable to send e-mail to #{email}"
    Logger.debug "status: #{status}"
    {:error, to_string(status) }
  end

end
