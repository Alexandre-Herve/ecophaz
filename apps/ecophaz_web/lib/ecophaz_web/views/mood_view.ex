defmodule EcophazWeb.MoodView do
  use EcophazWeb, :view
  alias EcophazWeb.MoodView

  def render("index.json", %{moods: moods}) do
    %{data: render_many(moods, MoodView, "mood.json")}
  end

  def render("show.json", %{mood: mood}) do
    %{data: render_one(mood, MoodView, "mood.json")}
  end

  def render("mood.json", %{mood: mood}) do
    %{id: mood.id,
      text: mood.text,
      type: mood.type}
  end
end
