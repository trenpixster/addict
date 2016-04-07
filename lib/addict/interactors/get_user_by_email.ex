defmodule Addict.Interactors.GetUserByEmail do
  @doc """
  Gets user by e-mail.
  Returns `{:ok, user}` or `{:error, [authentication: "Incorrect e-mail/password"]}`
  """
  def call(email, schema \\ Addict.Configs.user_schema, repo \\ Addict.Configs.repo) do
    repo.get_by(schema, email: email) |> process_response
  end

  defp process_response(nil) do
    {:error, [authentication: "Incorrect e-mail/password"]}
  end

  defp process_response(user) do
    {:ok, user}
  end

end
