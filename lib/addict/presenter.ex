defmodule Addict.Presenter do
@moduledoc """
Normalized structure presentation
"""

  @doc """
  Strips `:__struct__`, `:__meta__` and `:encrypted_password` from the structure
  """
  def strip_all(model) do
    model |> Map.drop([:__struct__, :__meta__, :encrypted_password])
  end

end