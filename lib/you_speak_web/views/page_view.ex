defmodule YouSpeakWeb.PageView do
  use YouSpeakWeb, :view

  def render("index.json", %{}) do
    %{status: :ok}
  end
end
