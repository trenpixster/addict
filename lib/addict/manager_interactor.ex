defmodule Addict.BaseManagerInteractor do
  @moduledoc """
    Addict BaseManagerInteractor is used as a base manager to be extended if needed.
    It's responsability is to provide simple primitives for
    user operations.
    """

  defmacro __using__(_) do
    quote do
      require Logger

      @derivation Application.get_env(:addict, :derivation) || Comeonin.Pbkdf2

      @doc """
        Throws exception when user params is invalid.
      """
      def create(nil) do
        throw "Invalid User hash: nil"
      end

      @doc """
        Creates a user on the database and sends the welcoming e-mail via the defined
        `mailer`.

        Required fields in `user_params` `Dict` are: `email`, `password`, `username`.
      """
      def create(user_params, repo \\ Addict.Repository, mailer \\ Addict.EmailGateway) do
        validate_params(user_params)
        |> generate_password
        |> create_username(repo)
        |> send_welcome_email(mailer)
      end

      @doc """
        Sends an e-mail to the user with a link to recover the password.
      """
      def recover_password(email, repo \\ Addict.Repository, mailer \\ Addict.EmailGateway) do
        prepare_password_recovery(email, repo)
        |> send_password_recovery_email(mailer)
      end

      @doc """
        Verifies if the provided `password` is the same as the `password` for the user
        associated with the given `email`.
      """
      def verify_password(email, password, repo \\ Addict.Repository) do
        user = repo.find_by_email email
        if valid_credentials(user, password) do
          {:ok, user}
        else
          {:error, "incorrect user or password"}
        end
      end

      @doc """
        Triggers an error when `password` and `password_confirm` mismatch.
      """
      def reset_password(_, password, password_confirm, _) when password != password_confirm do
        {:error, "passwords must match"}
      end

      @doc """
        Triggers an error when `recovery_hash` is invalid.
      """
      def reset_password(recovery_hash, _, _, _)
        when is_nil(recovery_hash)
        or recovery_hash == "" do
          {:error, "invalid recovery hash"}
        end

        @doc """
          Resets the password for the user with the given `recovery_hash`.
        """
        def reset_password(recovery_hash, password, _, repo \\ Addict.Repository) do
          {hash, _} = generate_password(%{"password" => password})
          repo.find_by_recovery_hash(recovery_hash)
          |> reset_user_password(hash, repo)
        end

        #
        # Private functions
        #

        defp reset_user_password(nil,_,_) do
          {:error, "invalid recovery hash"}
        end

        defp reset_user_password({:error, message},_,_) do
          {:error, message}
        end

        defp reset_user_password(user, hash, repo) do
          repo.change_password(user, hash)
        end


        defp prepare_password_recovery(email, repo) do
          hash = @derivation.hashpwsalt "1"
          repo.find_by_email(email)
          |> repo.add_recovery_hash(hash)
        end

        defp validate_params(nil) do
          throw "Unable to create user, invalid hash: nil"
        end

        defp validate_params(user_params) do
          case is_nil(user_params["email"])
               or is_nil(user_params["password"])
               or is_nil(user_params["username"]) do
                 false -> user_params
                 true -> throw "Unable to create user, invalid hash. Required params: email, password, username"
               end
        end

        defp create_username({hash, user_params}, repo) do
          user_params = Map.delete(user_params, "password")
          |> Map.put("hash", hash)
          repo.create(user_params)
        end

        defp send_password_recovery_email({:ok, nil}, _) do
          {:error, "Unable to send recovery e-mail"}
        end

        defp send_password_recovery_email({:ok, user}, mailer) do
          result = mailer.send_password_recovery_email(user)
          case result do
            {:ok, _} -> {:ok, user}
            {:error, message} -> {:error, message}
          end
        end

        defp send_password_recovery_email({:error, _}, _) do
          {:error, "Unable to send recovery e-mail"}
        end

        defp send_welcome_email({:ok, user}, mailer) do
          result = mailer.send_welcome_email(user)
          case result do
            {:ok, _} -> {:ok, user}
            {:error, message} -> {:error, message}
          end
        end

        defp send_welcome_email({:error, message}, _) do
          {:error, message}
        end

        defp valid_credentials(nil, _) do
          false
        end

        defp valid_credentials(user, password) do
          @derivation.checkpw(password, user.hash)
        end

        defp generate_password(user_params) do
          hash = @derivation.hashpwsalt user_params["password"]
          {hash, user_params}
        end
    end
  end
end

defmodule Addict.ManagerInteractor do
  @moduledoc """
  Default manager used by Addict
  """

  use Addict.BaseManagerInteractor
end
