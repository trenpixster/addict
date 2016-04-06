defmodule GeneratePasswordResetLinkTest do
  alias Addict.Interactors.GeneratePasswordResetLink
  use ExUnit.Case, async: true

  test "it generates a reset password path" do
    user_id = 123
    {:ok, result} = GeneratePasswordResetLink.call(user_id, "T01HLTEzMzctczNjcjM3NQ==")
    assert Regex.match?(~r/\/reset_password\?token=.+&signature=./, result)
  end

  test "it generates a custom reset password path" do
    user_id = 123
    {:ok, result} = GeneratePasswordResetLink.call(user_id, "T01HLTEzMzctczNjcjM3NQ==", "/woooh")
    assert Regex.match?(~r/\/woooh\?token=.+&signature=./, result)
  end

end
