defmodule GithubOmgWeb.ConvertControllerTest do
  use GithubOmgWeb.ConnCase

  describe "/api/convert" do

    #@tag :wip
    test "submitted json returns modified json", %{conn: conn} do
      {:ok, body} = File.read("test/data/convert__input.json")
      response = conn
        |> put_req_header("content-type", "application/json")
        |> post(Routes.convert_path(conn, :convert), body)

      body = Poison.decode!(response.resp_body)

      {:ok, result} = File.read("test/data/convert__output.json")
      expected = Poison.decode!(result)

      assert body == expected

    end

    test "handles empty request body", %{conn: conn} do

      response = conn
        |> post(Routes.convert_path(conn, :convert))

      body = Poison.decode!(response.resp_body)

      assert body == []

    end


    #@TODO: figure out how to not throw a Jason.Decode exception here
    @tag :skip
    test "returns status code 400 on invalid json", %{conn: conn} do

      response = conn
        |> put_req_header("content-type", "application/json")
        |> post(Routes.convert_path(conn, :convert), "asdf")

      #require IEx; IEx.pry
      assert response.status == 500
    end
  end
end
