defmodule Operator.Events.Webhook do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "webhook" do
    field :action_id, Ecto.UUID
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(webhook, attrs) do
    webhook
    |> cast(attrs, [:name, :description, :action_id])
    |> validate_required([:name, :description, :action_id])
  end
end
