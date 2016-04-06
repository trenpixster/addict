defmodule Addict.Presenter do

  def strip_all(model) do
    model |> Map.drop([:__struct__, :__meta__, :encrypted_password])
  end

end