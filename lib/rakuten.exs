
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

  alias SampleRakutenGenre.Repo
  alias SampleRakutenGenre.RakutenGenre

  def main do
    SampleRakutenGenre.Repo.start_link
    RakutenApi.start

    body = case RakutenApi.get(0) do
      {:ok, %{ body: body}} -> body
      res -> raise inspect res
    end

    save(0, body["children"])
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
    # TODO update complete
  end
end

Main.main
