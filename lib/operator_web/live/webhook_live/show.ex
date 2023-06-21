defmodule OperatorWeb.WebhookLive.Show do
  use OperatorWeb, :live_view

  alias Operator.Events

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:webhook, Events.get_webhook!(id))}
  end

  defp page_title(:show), do: "Show Webhook"
  defp page_title(:edit), do: "Edit Webhook"
end
