defmodule EcophazWeb.MoodController do
  use EcophazWeb, :controller

  alias Ecophaz.Content
  alias Ecophaz.Content.{Like, Mood}

  action_fallback EcophazWeb.FallbackController

  def index(conn, _params) do
    moods = Content.list_moods()
    render(conn, "index.json", moods: moods)
  end

  def create(conn, %{"mood" => mood_params}) do
    user = conn.assigns.signed_user
    params = mood_params |> Map.put("user_id", user.id)

    with {:ok, %Mood{} = mood} <- Content.create_mood(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.mood_path(conn, :show, mood))
      |> render("show.json", mood: mood)
    end
  end

  def show(conn, %{"id" => id}) do
    mood = Content.get_mood!(id)
    render(conn, "show.json", mood: mood)
  end

  def update(conn, %{"id" => id, "mood" => mood_params}) do
    user = conn.assigns.signed_user
    mood = Content.get_mood!(id)

    with :ok <- is_authorized(user.id, mood.user_id),
         {:ok, %Mood{} = mood} <- Content.update_mood(mood, mood_params) do
      render(conn, "show.json", mood: mood)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.signed_user
    mood = Content.get_mood!(id)

    with :ok <- is_authorized(user.id, mood.user_id),
         {:ok, %Mood{}} <- Content.delete_mood(mood) do
      send_resp(conn, :no_content, "")
    end
  end

  def like(conn, %{"id" => id}) do
    user = conn.assigns.signed_user
    mood = Content.get_mood!(id)

    with :ok <- is_authorized(user.id, mood.user_id),
         {:ok, %Like{}} <- mood |> Content.like(user.id) do
      conn |> send_resp(:created, "")
    end
  end

  def unlike(conn, %{"id" => id}) do
    user = conn.assigns.signed_user
    mood = Content.get_mood!(id)

    with :ok <- is_authorized(user.id, mood.user_id),
         {:ok, %Like{}} <- mood |> Content.unlike(user.id) do
      conn |> send_resp(:no_content, "")
    end
  end

  defp is_authorized(id1, id2) do
    if id1 == id2, do: :ok, else: {:error, :forbidden}
  end
end
