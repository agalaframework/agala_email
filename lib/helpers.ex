defmodule Agala.Provider.Email.Helpers do
  import Bamboo.Email

  def send_message(to, from, subject, message, mailer) do
    new_email
    |> to(to)
    |> from(from)
    |> subject(subject)
    |> html_body(message)
    |> mailer.deliver_now
  end
end
