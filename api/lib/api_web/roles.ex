defmodule ApiWeb.Roles do
  @moduledoc """
  Defines roles related functions.
  """

  alias Api.Accounts.User

  @type entity :: struct()
  @type action :: :new | :index | :edit | :show | :delete
  @spec can?(%User{}, entity(), action()) :: boolean()

  def can?(user, entity, action)
  def can?(_, _, _), do: false
end
