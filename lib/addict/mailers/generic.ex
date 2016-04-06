defmodule Addict.Mailers.Generic do
  @callback send_email(String.t, String.t, String.t, String.t) :: any
end
