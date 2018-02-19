defmodule Agala.Provider.Email.Chain.Parser do
  alias Agala.Provider.Email.Model.Response

  def init(_) do
    []
  end

  def call(
        conn = %Agala.Conn{
          request: request
        },
        _opts
      ) do
    conn
    |> Map.put(:request, parse_request(request))
  end

  def parse_request(
        {%{"From" => from, "Subject" => subject, "Message-ID" => message_id}, mail_parts}
      ) do
    [name: name, email: email] = parse_email_and_name(from)

    %Response{
      name: name,
      email: email,
      message_id: message_id,
      subject: subject,
      message: message_text(mail_parts)
    }
  end

  defp parse_email_and_name(email_from_field) do
    Pop3mail.WordDecoder.decode_text(email_from_field)
    |> parse_from_decoded
  end

  defp parse_from_decoded([{_, name}, {_, email}]) do
    [name: name, email: email]
  end

  defp parse_from_decoded([{_, name}, {_, email}]) do
    [name: name, email: email]
  end

  defp parse_from_decoded([{_, name_with_email}]) do
    [mail_part, email] = Regex.run(~r/<(.*?)>/, name_with_email)
    [name: String.trim(name_with_email, mail_part), email: email]
  end

  defp message_text(mail_parts) do
    mail_parts
    |> Enum.filter(fn mail_part -> mail_part.media_type == "text/plain" end)
    |> Enum.map(fn mail_part -> HtmlSanitizeEx.strip_tags(mail_part.content) end)
    |> Enum.join()
  end
end
