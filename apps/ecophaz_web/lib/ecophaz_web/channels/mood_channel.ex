defmodule EcophazWeb.MoodChannel do
  use EcophazWeb, :channel

  alias EcophazWeb.{
    Endpoint,
    MoodView
  }

  alias Ecophaz.Content.Mood

  alias Phoenix.View

  # =========================
  # Public API
  # =========================
  def broadcast_change(%Mood{} = mood) do
    payload = View.render(MoodView, "show.json", %{mood: mood})
    Endpoint.broadcast("moods:#{mood.id}", "change", payload)
  end

  # =========================
  # Internal
  # =========================
  def join("mood:" <> mood_id, payload, socket) do
    {:ok, socket}
  end
end
