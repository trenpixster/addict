defmodule Addict.Interactors.ValidatePassword do

  def call(changeset, nil) do
    call(changeset, [])
  end

  def call(changeset, strategies \\ []) do
    if Enum.count(strategies) == 0, do: strategies = [:default]

    messages = strategies
    |> Enum.reduce(changeset, fn (strategy, acc) ->
      validate(strategy, acc)
    end)
    |> format_response
  end

  defp format_response([]) do
    {:ok, []}
  end

  defp format_response(messages) do
    {:error, messages}
  end

  defp validate(:default, password) when is_bitstring(password) do
    if String.length(password) > 5, do: [], else: [{:password, "is too short"}]
  end

  defp validate(:default, changeset) do
    Ecto.Changeset.validate_change(changeset, :password, fn (field, value) ->
      validate(:default, value)
    end).errors
  end

end
