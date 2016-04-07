defmodule Addict.Mailers.Generic do
@moduledoc """
Defines the required behaviour for e-mail providers
"""
  @callback send_email(String.t, String.t, String.t, String.t) :: any
end
