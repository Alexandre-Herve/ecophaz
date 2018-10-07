defmodule EcophazWeb.MoodView do
  use EcophazWeb, :view
  alias EcophazWeb.MoodView
  import EcophazWeb.ViewHelpers

  @attributes ~w(id image text type likes)a

  def render("index.json", %{moods: moods}) do
    %{data: render_many(moods, MoodView, "mood.json")}
  end

  def render("show.json", %{mood: mood}) do
    %{data: render_one(mood, MoodView, "mood.json")}
  end

  def render("mood.json", %{mood: mood}) do
    mood
    |> Map.take(@attributes)
    |> put_loaded_assoc(:likes, LikeView, "index.json", :likes)
  end
end
