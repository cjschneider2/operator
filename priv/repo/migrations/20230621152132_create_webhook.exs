defmodule Operator.Repo.Migrations.CreateWebhook do
  use Ecto.Migration

  def change do
    create table(:webhook, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :action_id, :uuid

      timestamps()
    end
  end
end
