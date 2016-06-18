defmodule TestDumbHasher do
  @moduledoc """
  A dumb password hasher for testing purposes
  """

  def hashpwsalt(password) do
    "dumb-#{password}-password"
  end

  def checkpw(password, salt) do
    salt == hashpwsalt(password)
  end
end
