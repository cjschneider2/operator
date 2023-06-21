defmodule Operator.EventsTest do
  use Operator.DataCase

  alias Operator.Events

  describe "webhook" do
    alias Operator.Events.Webhook

    import Operator.EventsFixtures

    @invalid_attrs %{action_id: nil, description: nil, name: nil}

    test "list_webhook/0 returns all webhook" do
      webhook = webhook_fixture()
      assert Events.list_webhook() == [webhook]
    end

    test "get_webhook!/1 returns the webhook with given id" do
      webhook = webhook_fixture()
      assert Events.get_webhook!(webhook.id) == webhook
    end

    test "create_webhook/1 with valid data creates a webhook" do
      valid_attrs = %{action_id: "7488a646-e31f-11e4-aace-600308960662", description: "some description", name: "some name"}

      assert {:ok, %Webhook{} = webhook} = Events.create_webhook(valid_attrs)
      assert webhook.action_id == "7488a646-e31f-11e4-aace-600308960662"
      assert webhook.description == "some description"
      assert webhook.name == "some name"
    end

    test "create_webhook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_webhook(@invalid_attrs)
    end

    test "update_webhook/2 with valid data updates the webhook" do
      webhook = webhook_fixture()
      update_attrs = %{action_id: "7488a646-e31f-11e4-aace-600308960668", description: "some updated description", name: "some updated name"}

      assert {:ok, %Webhook{} = webhook} = Events.update_webhook(webhook, update_attrs)
      assert webhook.action_id == "7488a646-e31f-11e4-aace-600308960668"
      assert webhook.description == "some updated description"
      assert webhook.name == "some updated name"
    end

    test "update_webhook/2 with invalid data returns error changeset" do
      webhook = webhook_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_webhook(webhook, @invalid_attrs)
      assert webhook == Events.get_webhook!(webhook.id)
    end

    test "delete_webhook/1 deletes the webhook" do
      webhook = webhook_fixture()
      assert {:ok, %Webhook{}} = Events.delete_webhook(webhook)
      assert_raise Ecto.NoResultsError, fn -> Events.get_webhook!(webhook.id) end
    end

    test "change_webhook/1 returns a webhook changeset" do
      webhook = webhook_fixture()
      assert %Ecto.Changeset{} = Events.change_webhook(webhook)
    end
  end
end
