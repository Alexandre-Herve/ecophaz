defmodule Ecophaz.ContentTest do
  use Ecophaz.DataCase

  alias Ecophaz.Content
  alias Ecophaz.Content.{Like}
  import Ecophaz.Factory

  describe "moods" do
    alias Ecophaz.Content.Mood

    test "list_moods/0 returns all moods" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      moods = Content.list_moods()
      assert moods |> Enum.map(& &1.id) == [mood] |> Enum.map(& &1.id)
      assert moods |> List.first() |> Map.get(:user)
    end

    test "get_mood!/1 returns the mood with given id" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      assert Content.get_mood!(mood.id).id == mood.id
    end

    test "create_mood/1 with valid data creates a mood" do
      user = insert(:user)
      mood_params = params_for(:mood, user_id: user.id)
      assert {:ok, %Mood{} = mood} = Content.create_mood(mood_params)
      assert mood.text == mood_params.text
      assert mood.type == mood_params.type
    end

    test "create_mood/1 with invalid data returns error changeset" do
      mood_params = params_for(:mood) |> invalidate
      assert {:error, %Ecto.Changeset{}} = Content.create_mood(mood_params)
    end

    test "update_mood/2 with valid data updates the mood" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      mood_params = params_for(:mood)

      text = mood_params.text
      type = mood_params.type

      assert {:ok,
              %Mood{
                text: ^text,
                type: ^type
              } = mood} = Content.update_mood(mood, mood_params)
    end

    test "update_mood/2 with invalid data returns error changeset" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      mood_params = build(:mood) |> invalidate
      assert {:error, %Ecto.Changeset{}} = Content.update_mood(mood, mood_params)
      assert mood.id == Content.get_mood!(mood.id).id
    end

    test "delete_mood/1 deletes the mood" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      assert {:ok, %Mood{}} = Content.delete_mood(mood)
      assert_raise Ecto.NoResultsError, fn -> Content.get_mood!(mood.id) end
    end

    test "change_mood/1 returns a mood changeset" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      assert %Ecto.Changeset{} = Content.change_mood(mood)
    end

    test "like_mood/2 returns a like" do
      user = insert(:user)
      user_id = user.id
      mood = insert(:mood, user: user)
      mood_id = mood.id

      assert {:ok,
              %Content.Like{
                user_id: ^user_id,
                mood_id: ^mood_id
              }} = mood |> Content.like_mood(user_id)
    end

    test "like_mood/2 returns an error when the like exists" do
      user = insert(:user)
      user_id = user.id
      mood = insert(:mood, user: user)
      insert(:like, user: user, mood: mood)
      assert {:error, :already_liked} = mood |> Content.like_mood(user_id)
    end

    test "unlike_mood/2 deletes associated like" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      insert(:like, user: user, mood: mood)
      assert {:ok, %Like{}} = mood |> Content.unlike_mood(user.id)
    end

    test "unlike_mood/2 returns an error when the like doesn't exit" do
      user = insert(:user)
      mood = insert(:mood, user: user)
      assert {:error, :not_liked} = mood |> Content.unlike_mood(user.id)
    end
  end
end
