defmodule EmailTest do
  use ExUnit.Case
  doctest Agala.Provider.Email
  alias Agala.BotParams

  test "init returns :ok and bot params" do
    bot_configuration = %BotParams{
      provider_params: %{
        username: "user",
        password: "secure",
        server: "mail.server.ru"
      }
    }

    expected_bot_configuration =
      Map.put(
        bot_configuration,
        :private,
        %{
          mail_fetcher_module: Agala.Provider.Email.Protocol.Pop3.Mock
        }
      )

    assert {:ok, ^expected_bot_configuration} =
             Agala.Provider.Email.Poller.bootstrap(bot_configuration)
  end
end
