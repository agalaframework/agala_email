defmodule Agala.Provider.Email.Poller do
  @moduledoc """
  ### How poller works?
  Poller gets all needed options in `start_link/1` argument. In these options `:chain`
  is specified.
  So the Poller make periodical work:
  1. HTTP get new updates from Telegram server
  2. Split this array into separate event
  3. Handle particular each event with chain
  4. Restart cycle again
  """

  @pop3 Agala.Provider.Email.Protocol.Pop3
  @pop3_mock Agala.Provider.Email.Protocol.Pop3.Mock

  use Agala.Bot.Common.Poller
  alias Agala.BotParams

  #######################################################################################
  ### Initialize section
  #######################################################################################

  @spec bootstrap(Agala.BotParams.t()) :: {:ok, Agala.BotParams}
  def bootstrap(bot_params) do
    {
      :ok,
      Map.put(bot_params, :private, %{
        mail_fetcher_module: (Mix.env() == :test && @pop3_mock) || @pop3
      })
    }
  end

  #######################################################################################
  ### Get updates section
  #######################################################################################

  @spec get_updates(bot_params :: Agala.BotParams.t()) :: {list(), Agala.BotParams.t()}
  def get_updates(bot_params = %BotParams{}) do
    mail_proto = private_options(bot_params)

    {:ok, client} = mail_proto.connect(mail_options(bot_params))
    {:ok, mails} = mail_proto.scan(client)

    Logger.debug("Email retrieving started. Total count of messages in box: #{length(mails)}")

    updates =
      Enum.map(mails, fn {id, _} ->
        # @todo: use poolboy and asynk tasks
        {:ok, bin_message} = mail_proto.retrieve(client, id)

        mail_proto.delete(client, id)
        mail_proto.parse_binary(bin_message)
      end)

    mail_proto.disconnect(client)

    :timer.sleep(updates_interval(bot_params))

    {updates, bot_params}
  end

  defp private_options(%BotParams{
         private: %{
           mail_fetcher_module: mail_fetcher_module
         }
       }),
       do: mail_fetcher_module

  defp updates_interval(%BotParams{provider_params: %{updates_interval: interval}}), do: interval

  defp mail_options(%BotParams{} = opts) do
    Map.get(opts, :provider_params)
  end
end
