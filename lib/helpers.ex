defmodule Agala.Provider.Email.Helpers do
  import Bamboo.Email

  def send_message(to, from, subject, message, reply_message_id, mailer) do
    new_email
    |> to(to)
    |> from(from)
    |> subject(subject)
    |> html_body(message)
    |> put_header("In-Reply-To", reply_message_id)
    |> put_header("References", reply_message_id)
    |> mailer.deliver_now
  end
end
