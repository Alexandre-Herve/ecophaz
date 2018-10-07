defmodule Ecophaz.Content do
  @moduledoc """
  The Content context.
  """
  import Ecto.Query, warn: false
  alias Ecophaz.Repo

  alias Ecophaz.Accounts.{User}
  alias Ecophaz.Content.{Like, Mood}

  def list_moods do
    Repo.all(Mood)
  end

  def get_mood!(id), do: Repo.get!(Mood, id)

  def create_mood(attrs \\ %{}) do
    %Mood{}
    |> Mood.changeset(attrs)
    |> Repo.insert()
  end

  def update_mood(%Mood{} = mood, attrs) do
    mood
    |> Mood.changeset(attrs)
    |> Repo.update()
  end

  def delete_mood(%Mood{} = mood) do
    Repo.delete(mood)
  end

  def change_mood(%Mood{} = mood) do
    Mood.changeset(mood, %{})
  end

  def like_mood(%User{id: user_id}, mood_id) do
    %Like{mood_id: mood_id, user_id: user_id} |> Repo.insert
  end
end
