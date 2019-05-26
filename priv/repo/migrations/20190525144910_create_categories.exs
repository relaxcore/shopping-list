defmodule TestTask.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end

    alter table(:items) do
      add :category_id, :binary_id
    end
  end
end
