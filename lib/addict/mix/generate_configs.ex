defmodule Mix.Tasks.Addict.Generate.Configs do
  use Mix.Task

  def run(_) do
    configs_path = "./config/config.exs"

    if addict_config_already_exists?(configs_path) do
      Mix.shell.error "[x] Please remove the existing Addict configuration before generating a new one"
    else
      base_module = guess_application_name
      user_schema = "#{base_module}.User"
      repo        = "#{base_module}.Repo"

      Mix.shell.info "[o] Generating Addict configuration"

      guessed = Mix.shell.yes? "Is your application root module #{base_module}?"
      base_module = 
        case guessed do
          true -> base_module
          false -> Mix.shell.prompt("Please insert your application root module:") |> String.rstrip
        end

      guessed = Mix.shell.yes? "Is your Ecto Repository module #{repo}?"
      repo = 
        case guessed do
          true -> repo
          false -> Mix.shell.prompt("Please insert your Ecto Repository module:") |> String.rstrip
        end

      guessed = Mix.shell.yes? "Is your User Schema module #{user_schema}?"
      user_schema = 
        case guessed do
          true -> user_schema
          false -> Mix.shell.prompt("Please insert your User Schema module:") |> String.rstrip
        end

      use_mailgun = Mix.shell.yes? "Will you be using Mailgun?"
      mailgun_domain = 
        case use_mailgun do
          true -> Mix.shell.prompt("Please insert your Mailgun domain: (e.g.: https://api.mailgun.net/v3/sandbox123456.mailgun.org)") |> String.rstrip
          false -> ""
        end

      mailgun_api_key = 
        case use_mailgun do 
          true -> Mix.shell.prompt("Please insert your Mailgun API key:") |> String.rstrip
          false -> ""
        end

      add_addict_configs(configs_path, user_schema, repo, use_mailgun, mailgun_domain, mailgun_api_key)
    end

    Mix.shell.info "[o] Done!"
  end

  defp guess_application_name do
    Mix.Project.config()[:app] |> Atom.to_string |> Mix.Utils.camelize
  end

  defp addict_config_already_exists?(configs_path) do
    {data} = with  {:ok, file} <- File.open(configs_path, [:read, :write, :utf8]),
          data <- IO.read(file, :all),
          :ok <- File.close(file),
      do: {data}

    Regex.match?  ~r/config :addict\s*?,/, data
  end

  defp add_addict_configs(configs_path, user_schema, repo, use_mailgun, mailgun_domain, mailgun_api_key) do
    {:ok, file} = File.open(configs_path, [:read, :write, :utf8])
    IO.read(file, :all)
    secret_key = Comeonin.Bcrypt.gen_salt |> Base.encode16 |> String.downcase

    default_configs = """

    config :addict,
      secret_key: "#{secret_key}",
      extra_validation: fn ({valid, errors}, user_params) -> {valid, errors} end, # define extra validation here
      user_schema: #{user_schema},
      repo: #{repo},
      from_email: "no-reply@example.com", # CHANGE THIS
    """

    default_configs = if use_mailgun do
      default_configs <> """
        mailgun_domain: "#{mailgun_domain}",
        mailgun_key: "#{mailgun_api_key}",
        mail_service: :mailgun
      """
    else
      default_configs <> "mail_service: nil"
    end

    IO.write(file, default_configs)
    :ok = File.close(file)
  end
end
