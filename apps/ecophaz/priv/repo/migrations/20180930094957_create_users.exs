defmodule Ecophaz.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string, null: false
      add :name, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
