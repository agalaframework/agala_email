defmodule EmailReceiverTest do
  use ExUnit.Case
  doctest Agala.Provider.Email
  alias Agala.BotParams
  alias Agala.Provider.Email.Poller

  @bot_configuration %BotParams{
    provider_params: %{
      login: "user",
      password: "secure",
      server: "mail.server.ru",
      port: 995,
      email: "user@example.com",
      updates_interval: 5 * 1_000
    }
  }

  test "get_updates call applies handler" do
    {:ok, bot_params} = Poller.bootstrap(@bot_configuration)
    assert {_updates, ^bot_params} = Poller.get_updates(bot_params)
  end
end
