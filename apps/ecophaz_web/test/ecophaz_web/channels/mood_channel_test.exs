defmodule EcophazWeb.MoodChannelTest do
  use EcophazWeb.ChannelCase

  alias Ecophaz.Content
  alias Phoenix.View
  alias EcophazWeb.{MoodChannel, MoodView}
  import Ecophaz.Factory

  setup do
    user = insert(:user)
    mood = insert(:mood, user: user)

    {:ok, _, socket} =
      socket(EcophazWeb.UserSocket, "user_id", %{signed_user: user})
      |> subscribe_and_join(EcophazWeb.MoodChannel, "mood:#{mood.id}")

    {:ok, socket: socket, mood: mood}
  end

  test "broadcast pushes to the clients", %{socket: socket, mood: mood} do
    text = "some test text"
    {:ok, mood} = mood |> Content.update_mood(%{"text" => text})
    data = View.render(MoodView, "show.json", %{mood: mood})

    broadcast_from!(socket, "change", %{"data" => data})
    assert_push("change", %{"data" => ^data})
  end

  test "broadcast_change pushes json mood to the clients", %{socket: _socket, mood: mood} do
    EcophazWeb.Endpoint.subscribe("moods:#{mood.id}")
    text = "some test text"
    {:ok, mood} = mood |> Content.update_mood(%{"text" => text})
    data = View.render(MoodView, "show.json", %{mood: mood})
    MoodChannel.broadcast_change(mood)
    assert_broadcast("change", ^data)
  end
end
