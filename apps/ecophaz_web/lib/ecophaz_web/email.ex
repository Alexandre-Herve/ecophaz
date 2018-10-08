defmodule EcophazWeb.Email do
  import Bamboo.Email

  def request_change_password_email(email, _name, token) do
    new_email()
    |> to(email)
    |> from("support@ecophaz.com")
    |> subject("Your Ecophaz reset password token")
    |> html_body("<strong>#{token}</strong>")
    |> text_body("#{token}")
  end
end
