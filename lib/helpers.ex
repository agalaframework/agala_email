defmodule Agala.Provider.Email.Helpers do
  import Bamboo.Email

  def generate_message(to, from, subject) do
    new_email
    |> to(to)
    |> from(from)
    |> subject(subject)
  end
end
