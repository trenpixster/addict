defmodule VerifyPasswordTest do
  alias Addict.Interactors.VerifyPassword
  use ExUnit.Case, async: true

  test "it validates correct passwords" do
    user = %TestAddictSchema{encrypted_password: "$pbkdf2-sha512$100000$od8q.7wWyoUzThxnm7mnHQ$kW4PEzo9l/f.emd5khI3EhpjQaLMKecCTl3YrPNglhYNzCtyfmaggCtHWDpM7MS/Kv4eewwl12HbcHiMn3nnPg"}
    {status} = VerifyPassword.call(user, "ma password")
    assert status == :ok
  end

  test "it validates incorrect passwords" do
    user = %TestAddictSchema{encrypted_password: "$pbkdf2-sha512$100000$od8q.7wWyoUzThxnm7mnHQ$kW4PEzo9l/f.emd5khI3EhpjQaLMKecCTl3YrPNglhYNzCtyfmaggCtHWDpM7MS/Kv4eewwl12HbcHiMn3nnPg"}
    {status, errors} = VerifyPassword.call(user, "incorrect password")
    assert status == :error
    assert errors == [authentication: "Incorrect e-mail/password"]
  end
end
