defmodule Mix.Tasks.Addict.Generate.Boilerplate do
  use Mix.Task
  import Mix.Generator
  embed_text :login, from_file: "./boilerplate/login.html.eex"
  embed_text :template, from_file: "./boilerplate/addict.html.eex"
  embed_text :register, from_file: "./boilerplate/register.html.eex"
  embed_text :reset_password, from_file: "./boilerplate/reset_password.html.eex"
  embed_text :recover_password, from_file: "./boilerplate/recover_password.html.eex"
  embed_template :view, """
  defmodule Addict.AddictView do
    use Phoenix.HTML
    use Phoenix.View, root: "web/templates/"
    import Phoenix.Controller, only: [view_module: 1]
    import <%= @base_route_helper %>
  end
  """

  def run(_) do
    configs_path = "./config/config.exs"

    if !addict_config_already_exists?(configs_path) do
      Mix.shell.error "[x] Please make sure your Addict configuration exists first. Generate it via mix:"
      Mix.shell.error "[x] mix addict.generate.configs"
    else
      base_module = guess_application_name
      Mix.shell.info "[o] Generating Addict boilerplate"

      create_addict_templates
      create_addict_view
    end

    Mix.shell.info "[o] Done!"
  end

  defp create_addict_templates do
    create_file Path.join(["web", "templates", "addict", "addict.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                template_text
    create_file Path.join(["web", "templates", "addict", "login.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                login_text
    create_file Path.join(["web", "templates", "addict", "register.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                register_text
    create_file Path.join(["web", "templates", "addict", "recover_password.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                recover_password_text
    create_file Path.join(["web", "templates", "addict", "reset_password.html.eex"])
                |> Path.relative_to(Mix.Project.app_path),
                reset_password_text
  end

  defp create_addict_view do
    view_file = Path.join(["web", "views", "addict_view.ex"])
                |> Path.relative_to(Mix.Project.app_path)
    create_file view_file, view_template(base_route_helper: (guess_application_name <> ".Router.Helpers"))
  end

  defp guess_application_name do
    Mix.Project.config()[:app] |> Atom.to_string |> Mix.Utils.camelize
  end

  defp addict_config_already_exists?(configs_path) do
    {data} = with  {:ok, file} <- File.open(configs_path, [:read, :write, :utf8]),
          data <- IO.read(file, :all),
          :ok <- File.close(file),
      do: {data}

    String.contains?(data, "config :addict")
  end
end
