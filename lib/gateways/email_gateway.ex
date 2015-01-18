defmodule Addict.EmailGateway do
  def send_welcome_email(user, mailer \\ Addict.MailgunMailer) do
    mailer.send_email_to_user "#{user.username} <#{user.email}>",
                       Application.get_env(:addict, :register_from_email),
                       Application.get_env(:addict, :register_subject),
                       Application.get_env(:addict, :email_templates).register_template(user)
  end
end