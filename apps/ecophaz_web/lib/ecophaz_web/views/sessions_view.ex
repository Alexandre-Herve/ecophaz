defmodule EcophazWeb.SessionsView do
  use EcophazWeb, :view

  def render("show.json", auth_token) do
    %{data: %{token: auth_token.token}}
  end
end
