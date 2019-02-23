defmodule Github do

  @uri "https://api.github.com"

  def search_repositories(query, page \\ 1, per_page \\ 10) do
    "#{@uri}/search/repositories?q=#{query}&per_page=#{per_page}&page=#{page}"
      |> get
  end

  defp get(uri) do
    case HTTPoison.get(uri) do
      {:ok, response} -> decode(response)
      {:error, message} -> %{error: message}
    end
  end

  defp decode(response) do
    case Poison.decode(response.body) do
      {:ok, response} -> response
      {:error, message} -> %{error: message}
    end
  end
end
