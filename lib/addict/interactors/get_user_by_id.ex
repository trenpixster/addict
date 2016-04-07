defmodule Addict.Interactors.GetUserById do
  @doc """
  Gets user by e-mail.
  Returns `{:ok, user}` or `{:error, [user_id: "Unable to find user"]}`
  """
  def call(id, schema \\ Addict.Configs.user_schema, repo \\ Addict.Configs.repo) do
    repo.get_by(schema, id: id) |> process_response
  end

  defp process_response(nil) do
    {:error, [user_id: "Unable to find user"]}
  end

  defp process_response(user) do
    {:ok, user}
  end

end
