defmodule EmailTest do
  use ExUnit.Case
  doctest Agala.Provider.Email
  alias Agala.BotParams

  test "init returns :ok and bot params" do
    bot_configuration = %BotParams{
      provider_params: %{
        username: "user", password: "secure", server: "mail.server.ru"
      }
    }

    assert {:ok, ^bot_configuration} = Agala.Provider.Email.init(bot_configuration)
  end
end
