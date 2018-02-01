defmodule Agala.Provider.Email.Receiver do
  @moduledoc """
  Module providing email connection fetch.
  """
  use Agala.Bot.Receiver
  alias Agala.BotParams
  @mail_proto Agala.Provider.Email.Protocol.Pop3.Mock

  def get_updates(notify_with, bot_params = %BotParams{}) do
    mail_proto = private_options(bot_params)

    {:ok, client} = mail_proto.connect(mail_options(bot_params))
    {:ok, mails} = mail_proto.scan(client)

    Enum.map(mails, fn {id, _} ->
      #@todo: use poolboy and asynk tasks
      {:ok, bin_message} = mail_proto.retrieve(client, id)

      mail_proto.parse_binary(bin_message)
      |> resolve_mail(notify_with)
    end)
    :timer.sleep 1_000
    bot_params
  end

  defp mail_options(%BotParams{
        provider_params: %{
          login: login, email: email, password: password, server: server,
          port: port
        }
      }
  ), do: %{email: email, password: password, server: server, port: port, login: login}

  defp private_options(%BotParams{
        private: %{
          mail_fetcher_module: mail_fetcher_module
        }
     }
  ), do: mail_fetcher_module

  defp resolve_mail({h, c}, notify_with) do
    notify_with.({h, c})
  end
end
