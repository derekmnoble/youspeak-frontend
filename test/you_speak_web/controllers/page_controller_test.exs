defmodule YouSpeakWeb.PageControllerTest do
  use YouSpeakWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "YouSpeak"
  end
end
