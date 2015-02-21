defmodule Addict.PasswordInteractor do
  @derivation Application.get_env(:addict, :derivation) || Comeonin.Pbkdf2

  def generate_random_hash() do
    @derivation.hashpwsalt "1"
  end

  def generate_hash(password) do
    @derivation.hashpwsalt password
  end

  def verify_credentials(hash, password) do
    @derivation.checkpw password, hash
  end

end