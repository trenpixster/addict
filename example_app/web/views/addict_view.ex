defmodule Addict.AddictView do
  use Phoenix.HTML
  use Phoenix.View, root: "web/templates/"
  import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]
  import ExampleApp.Router.Helpers
end
