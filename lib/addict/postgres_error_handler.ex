defmodule PostgresErrorHandler do
  @moduledoc """
  Handles Postgres errors and provides friendly messages on known failures.
  """
  require Logger

  @doc """
  Handles errors for Addict Repository interactions.
  """
  def handle_error(Addict.Repository, postgres_error) do
    case postgres_error.postgres.code do
      "23505" -> {:error, "User already exists"}
      _ -> handle_unknown_error(postgres_error.postgres)
    end
  end

  @doc """
  Handles generic errors.
  """
  def handle_error(_, postgres_error) do
    handle_unknown_error(postgres_error.postgres)
  end

  defp handle_unknown_error(postgres_error) do
    Logger.debug "unknown error caught: #{postgres_error.code}"
    IO.inspect postgres_error
    {:error, "Unknow error: #{postgres_error.code}"}
  end

end
