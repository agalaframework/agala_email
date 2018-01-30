defmodule Agala.Provider.Email do
  @moduledoc """
  Module providing email connection.
  """

  use Agala.Provider

  def init(bot_params) do
    {
      :ok,
      bot_params
    }
  end
end
