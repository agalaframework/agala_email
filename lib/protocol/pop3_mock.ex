defmodule Agala.Provider.Email.Protocol.Pop3.Mock do
  @moduledoc """
  Implementation of mock module for Pop3 mail protocol of Agala framework.
  For testing purposes
  """
  alias Agala.Provider.Email.Protocol.Pop3

  def connect(%{email: _, password: _, server: _, port: _, login: _}) do
    {:ok,
     {:sk, 'user', 'mail.example.com',
      {:sslsocket, {:gen_tcp, "some_port", :tls_connection, :undefined}, self()}, 995, false,
      false, true}}
  end

  def scan(_client) do
    {:ok, [{1, 1948}, {2, 1923}, {3, 1123}]}
  end

  def retrieve(_client, id) do
    {:ok,
     "To: <receiver@example.com@yandex.ru>\r\nFrom: Sender <sender@example.com>\r\nSubject: =?UTF-8?B?0LLQvtC/0YDQvtGBINC/0L4g0LrRgNC10LTQuNGC0YM=?=\r\nDate: Tue, 30 Jan 2018 16:22:53 +0300\r\nUser-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101\r\n Thunderbird/52.5.2\r\nMIME-Version: 1.0\r\nContent-Type: text/plain; charset=\"utf-8\"; format=flowed\r\nContent-Transfer-Encoding: 8bit\r\nContent-Language: en-US\r\n\r\nmessage number #{
       id
     }\r\n\r\n"}
  end

  def delete(_client, _id) do
    :ok
  end

  def disconnect(_client) do
    :ok
  end

  def parse_binary(raw_binary) do
    Pop3.parse_binary(raw_binary)
  end

  def parse_headers({:message, headers, content}) do
    Pop3.parse_headers({:message, headers, content})
  end

  def parse_content({:message, headers, content}) do
    Pop3.parse_content({:message, headers, content})
  end
end
