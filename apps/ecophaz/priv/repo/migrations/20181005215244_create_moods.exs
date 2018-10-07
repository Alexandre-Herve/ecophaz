defmodule Ecophaz.Repo.Migrations.CreateMoods do
  use Ecto.Migration

  def change do
    create table(:moods) do
      add :text, :string
      add :type, :string
      add :image, :string
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:moods, [:user_id])
  end
end
