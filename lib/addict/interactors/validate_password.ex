defmodule Addict.Interactors.ValidatePassword do

  @doc """
  Validates a password according to the defined strategies.
  For now, only the `:default` strategy exists: password must be at least 6 chars long.

  Returns `{:ok, []}` or `{:error, [errors]}`
  """
  def call(changeset, nil) do
    call(changeset, [])
  end

  def call(changeset, strategies) do
    strategies = 
      case Enum.count(strategies) do
        0 -> [:default]
        _ -> strategies
      end

    strategies
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
    if String.length(password) > 5, do: [], else: [{:password, {"is too short", []}}]
  end

  defp validate(:default, changeset) do
    Ecto.Changeset.validate_change(changeset, :password, fn (_field, value) ->
      validate(:default, value)
    end).errors
  end

end
