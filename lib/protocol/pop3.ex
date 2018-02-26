defmodule Agala.Provider.Email.Protocol.Pop3 do
  @moduledoc """
  Implementation of Pop3 mail protocol for Agala framework.
  Based on nico-amsterdam/pop3mail
  """

  def connect(%{email: email, password: password, server: server, port: port, login: login}) do
    :epop_client.connect(email, password, [{:addr, server}, {:port, port}, {:user, login}, :ssl])
  end

  def scan(client) do
    :epop_client.scan(client)
  end

  def retrieve(client, id) do
    :epop_client.bin_retrieve(client, id)
  end

  def delete(client, id) do
    :epop_client.delete(client, id)
  end

  def disconnect(client) do
    :epop_client.quit(client)
  end

  def parse_binary(raw_binary) do
    {:message, h, c} =
      raw_binary
      |> :epop_message.bin_parse()
      |> parse_content
      |> parse_headers

    {h, c}
  end

  def parse_headers({:message, headers, content}) do
    parsed_headers =
      headers
      |> Enum.reduce(%{}, fn {:header, key, val}, acc ->
        Map.put(acc, key, val)
      end)

    {:message, parsed_headers, content}
  end

  def parse_content({:message, headers, content}) do
    parsed_content = Pop3mail.decode_body_content(headers, content)
    {:message, headers, parsed_content}
  end
end
