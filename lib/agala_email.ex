defmodule Agala.Provider.Email do
  @moduledoc """
  Module providing email connection.
  """
  use Agala.Provider

  @pop3 Agala.Provider.Email.Protocol.Pop3
  @pop3_mock Agala.Provider.Email.Protocol.Pop3.Mock

  def init(bot_params) do
    {
      :ok,
      Map.put(
        bot_params, :private, %{
          mail_fetcher_module: (Mix.env() == :test &&@pop3_mock || @pop3)
        }
      )
    }
  end
end
