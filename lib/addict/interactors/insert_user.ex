defmodule Addict.Interactors.InsertUser do
  def call(schema, user_params, repo) do
    user_params = for {key, val} <- user_params, into: %{}, do: {String.to_atom(key), val}
    repo.insert struct(schema, user_params)
  end
end
