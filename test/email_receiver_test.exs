defmodule EmailReceiverTest do
  use ExUnit.Case
  doctest Agala.Provider.Email
  alias Agala.BotParams
  alias Agala.Provider.Email
  alias Agala.Provider.Email.Receiver

  @bot_configuration %BotParams{
    provider_params: %{
      login: "user",
      password: "secure",
      server: "mail.server.ru",
      port: 995,
      email: "user@example.com"
    }
  }

  test "get_updates call applies handler" do
    {:ok, bot_params} = Email.init(@bot_configuration)
    assert [:ok, :ok, :ok] == Receiver.get_updates(fn _ -> :ok end, bot_params)
  end
end
