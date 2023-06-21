defmodule OperatorWeb.WebhookLive.Index do
  use OperatorWeb, :live_view

  alias Operator.Events
  alias Operator.Events.Webhook

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :webhook_collection, Events.list_webhook())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Webhook")
    |> assign(:webhook, Events.get_webhook!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Webhook")
    |> assign(:webhook, %Webhook{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Webhook")
    |> assign(:webhook, nil)
  end

  @impl true
  def handle_info({OperatorWeb.WebhookLive.FormComponent, {:saved, webhook}}, socket) do
    {:noreply, stream_insert(socket, :webhook_collection, webhook)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    webhook = Events.get_webhook!(id)
    {:ok, _} = Events.delete_webhook(webhook)

    {:noreply, stream_delete(socket, :webhook_collection, webhook)}
  end
end
