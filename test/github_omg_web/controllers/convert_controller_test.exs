defmodule GithubOmgWeb.ConvertControllerTest do
  use GithubOmgWeb.ConnCase

  describe "/api/convert" do

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

  end
end
