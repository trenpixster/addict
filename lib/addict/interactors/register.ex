defmodule Addict.Interactors.Register do
  alias Addict.Interactors.{ValidateUserForRegistration, InsertUser, InjectHash}

  def call(user_params, configs \\ Addict.Configs) do
    extra_validation = configs.extra_validation || fn (a,b) -> a end

    {valid, errors} = ValidateUserForRegistration.call(user_params)
    user_params = InjectHash.call user_params
    {valid, errors} = extra_validation.({valid, errors}, user_params)

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
