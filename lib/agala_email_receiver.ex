defmodule Agala.Provider.Email.Receiver do
  @moduledoc """
  Module providing email connection fetch.
  """
  use Agala.Bot.Receiver
  alias Agala.BotParams

  def get_updates(notify_with, bot_params = %BotParams{}) do
    mail_proto = private_options(bot_params)

    {:ok, client} = mail_proto.connect(mail_options(bot_params))
    {:ok, mails} = mail_proto.scan(client)

    Logger.debug("Email retrieving started. Total count of messages in box: #{length(mails)}")

    Enum.map(mails, fn {id, _} ->
      # @todo: use poolboy and asynk tasks
      {:ok, bin_message} = mail_proto.retrieve(client, id)

      mail_proto.parse_binary(bin_message)
      |> resolve_mail(notify_with)

      mail_proto.delete(client, id)
    end)

    mail_proto.disconnect(client)

    :timer.sleep(updates_interval(bot_params))
    bot_params
  end

  defp mail_options(%BotParams{} = opts), do: Map.get(opts, :provider_params)

  defp updates_interval(%BotParams{provider_params: %{updates_interval: interval}}), do: interval

  defp private_options(%BotParams{
         private: %{
           mail_fetcher_module: mail_fetcher_module
         }
       }),
       do: mail_fetcher_module

  defp resolve_mail({h, c}, notify_with) do
    notify_with.({h, c})
  end
end
