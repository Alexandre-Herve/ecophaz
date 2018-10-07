defmodule EcophazWeb.LikeView do
  use EcophazWeb, :view
  alias EcophazWeb.LikeView

  @attributes ~w(id)a

  def render("index.json", %{likes: likes}) do
    %{data: render_many(likes, LikeView, "like.json")}
  end

  def render("show.json", %{like: like}) do
    %{data: render_one(like, LikeView, "like.json")}
  end

  def render("like.json", %{like: like}) do
    like |> Map.take(@attributes)
  end
end
