defmodule Operator.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Operator.Events` context.
  """

  @doc """
  Generate a webhook.
  """
  def webhook_fixture(attrs \\ %{}) do
    {:ok, webhook} =
      attrs
      |> Enum.into(%{
        action_id: "7488a646-e31f-11e4-aace-600308960662",
        description: "some description",
        name: "some name"
      })
      |> Operator.Events.create_webhook()

    webhook
  end
end
