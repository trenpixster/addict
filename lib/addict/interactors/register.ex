defmodule Addict.Interactors.Register do
  alias Addict.Interactors.{ValidateUserForRegistration, InsertUser, InjectHash}

  @doc """
  Executes the user registration flow: parameters validation, password hash generation, user insertion and e-mail sending.
  Also applies custom defined `Addict.Configs.extra_validation/2`.

  Returns `{:ok, user}` or `{:error, [errors]}`
  """
  def call(user_params, configs \\ Addict.Configs) do
    extra_validation = configs.extra_validation || fn (a,_) -> a end

    {valid, errors} = ValidateUserForRegistration.call(user_params)
    user_params     = InjectHash.call user_params
    {valid, errors} = Addict.Helper.exec extra_validation, [{valid, errors}, user_params]

    case {valid, errors} do
       {:ok, _} -> do_register(user_params, configs)
       {:error, errors} -> {:error, errors}
    end

  end

  def do_register(user_params, configs) do
      with {:ok, user} <- InsertUser.call(configs.user_schema, user_params, configs.repo),
           {:ok, _} <- Addict.Mailers.MailSender.send_register(user_params),
       do: {:ok, user}
  end
end
