defmodule Agala.Provider.Email do
  use Agala.Provider

  @moduledoc """
  Module providing email connection.
  """

  defmacro __using__(:handler) do
    quote location: :keep do
      import Agala.Provider.Email.Helpers
    end
  end
end
