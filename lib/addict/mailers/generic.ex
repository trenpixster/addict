@moduledoc """
Defines the required behaviour for e-mail providers
"""
defmodule Addict.Mailers.Generic do
  @callback send_email(String.t, String.t, String.t, String.t) :: any
end
