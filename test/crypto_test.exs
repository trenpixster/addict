defmodule CryptoTest do
  use ExUnit.Case, async: true

  test "it ciphers with a given key" do
    key = "SQkFekcLjcPAHRIKc3t4z9hn0Mehimticphd2WUpXSo="
    signature = Addict.Crypto.sign("plain text", key)
    assert signature == "C6DA7D55E213A8D48B6077FCC6D9E6B98CED22A91D42AC9DDA68E15044BC52328D92A0AF051EB457416E2B922565E3FF75AEF0222291AAB3C7E43FD315DF8E72"
  end

  test "it is able to verify a signature" do
    key = "SQkFekcLjcPAHRIKc3t4z9hn0Mehimticphd2WUpXSo="
    signature = "C6DA7D55E213A8D48B6077FCC6D9E6B98CED22A91D42AC9DDA68E15044BC52328D92A0AF051EB457416E2B922565E3FF75AEF0222291AAB3C7E43FD315DF8E72"
    {_status, result} = Addict.Crypto.verify("plain text", key, signature)
    assert result == [token: "Password reset token not valid."]
  end

end
