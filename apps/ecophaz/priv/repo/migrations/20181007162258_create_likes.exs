defmodule Ecophaz.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :mood_id, references(:moods, on_delete: :delete_all)

      timestamps()
    end

    create index(:likes, [:user_id])
    create index(:likes, [:mood_id])
  end
end
