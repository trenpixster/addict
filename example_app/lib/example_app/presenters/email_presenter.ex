defmodule ExampleApp.Presenters.EmailPresenter do
  def register_template(user) do
    """
    <p><b>Hi #{user.username},</b></p>
    <p>Thanks for joining!</p>
    <p>Cheers!</p>
    <p></p>
    <p>ExampleApp</p>
    """
  end

  def password_recovery_template(user) do
    """
    <p><b>Hi #{user.username},</b></p>
    <p> It seems you've lost your password! </p>
    <p> Use this token <b>#{user.recovery_hash}"</b> to recover your password.</p>
    <p>
    <p>Cheers!</p>
    <p>ExampleApp</p>
    """
  end


end