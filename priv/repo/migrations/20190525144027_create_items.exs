defmodule TestTask.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :price, :float
      add :bougth, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:items, [:name])
  end
end
