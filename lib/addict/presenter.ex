defmodule Addict.Presenter do
@moduledoc """
Normalized structure presentation
"""

  @doc """
  Strips all associations, `:__struct__`, `:__meta__` and `:encrypted_password` from the structure

  Returns the stripped structure
  """
  def strip_all(model, schema \\ Addict.Configs.user_schema) do
    model |> drop_keys(schema)
  end

  defp drop_keys(model, schema) do
    associations = schema.__schema__(:associations)
    Map.drop model, associations ++ [:__struct__, :__meta__, :encrypted_password]
  end

end