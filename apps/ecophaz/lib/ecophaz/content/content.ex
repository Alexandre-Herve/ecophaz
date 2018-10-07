defmodule Ecophaz.Content do
  @moduledoc """
  The Content context.
  """
  import Ecto.Query, warn: false
  alias Ecophaz.Repo
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

  @spec like(%Mood{}, binary) ::
          nil | {:error, :bad_request} | {:error, %Ecto.Changeset{}} | {:ok, %Like{}}

  def like(%Mood{id: mood_id}, user_id) do
    Like
    |> Repo.get_by(mood_id: mood_id, user_id: user_id)
    |> case do
      nil -> %Like{mood_id: mood_id, user_id: user_id} |> Repo.insert()
      _ -> {:error, :bad_request}
    end
  end

  @spec unlike(%Mood{}, binary) ::
          nil | {:error, :not_found} | {:error, %Ecto.Changeset{}} | {:ok, %Like{}}

  def unlike(%Mood{id: mood_id}, user_id) do
    Like
    |> Repo.get_by(mood_id: mood_id, user_id: user_id)
    |> case do
      %Like{} = like -> like |> Repo.delete()
      _ -> {:error, :not_found}
    end
  end
end
