defmodule Agala.Provider.Email do
  @moduledoc """
  Module providing email connection.
  """
  use Agala.Provider

  def init(bot_params, _) do
    {
      :ok,
      Map.put(bot_params, :private, %{
        mail_fetcher_module: Application.get_env(:agala_email, :fetcher)
      })
    }
  end

  defmacro __using__(:handler) do
    quote location: :keep do
      import Agala.Provider.Email.Helpers
    end
  end
end
