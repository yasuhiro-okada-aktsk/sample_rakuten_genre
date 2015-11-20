
defmodule RakutenApi do
  use HTTPoison.Base

  def process_url(genreId) do
      "https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20140222?format=json&genreId=#{genreId}&applicationId=1019761769698164306&elements=children"
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end

defmodule Main do
  require Logger

  import Ecto.Query

  alias SampleRakutenGenre.Repo
  alias SampleRakutenGenre.RakutenGenre

  def main do
    SampleRakutenGenre.Repo.start_link
    RakutenApi.start

    fetch_uncompleted
  end

  def fetch_uncompleted() do
    genres = RakutenGenre
    |> where([g], g.completed == 0)
    |> Repo.all

    unless length(genres) == 0 do
      fetch(genres)
    end
  end

  def fetch([%{genre_id: parent}|tl]) do
    body = case RakutenApi.get(parent) do
      {:ok, %{ body: body}} -> body
      res -> raise inspect res
    end

    save(parent, body["children"])

    :timer.sleep(500)
    fetch(tl)
  end

  def fetch([]) do
    fetch_uncompleted()
  end

  def save(parent, [%{"child" => genre}|tl]) do
    changeset = %RakutenGenre{}
    |> RakutenGenre.changeset_insert(genre, parent)

    try do
      result = Repo.insert(changeset)
    rescue
      e -> Logger.error inspect e
    end

    save(parent, tl)
  end

  def save(parent, []) do
    unless parent == 0 do
      RakutenGenre
      |> where([g], g.genre_id == ^parent)
      |> Repo.one
      |> RakutenGenre.changeset_update
      |> Repo.update
    end
  end
end

Main.main
