defmodule OperatorWeb.WebhookLive.FormComponent do
  use OperatorWeb, :live_component

  alias Operator.Events

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage webhook records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="webhook-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:action_id]} type="text" label="Action" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Webhook</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{webhook: webhook} = assigns, socket) do
    changeset = Events.change_webhook(webhook)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"webhook" => webhook_params}, socket) do
    changeset =
      socket.assigns.webhook
      |> Events.change_webhook(webhook_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"webhook" => webhook_params}, socket) do
    save_webhook(socket, socket.assigns.action, webhook_params)
  end

  defp save_webhook(socket, :edit, webhook_params) do
    case Events.update_webhook(socket.assigns.webhook, webhook_params) do
      {:ok, webhook} ->
        notify_parent({:saved, webhook})

        {:noreply,
         socket
         |> put_flash(:info, "Webhook updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_webhook(socket, :new, webhook_params) do
    case Events.create_webhook(webhook_params) do
      {:ok, webhook} ->
        notify_parent({:saved, webhook})

        {:noreply,
         socket
         |> put_flash(:info, "Webhook created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
