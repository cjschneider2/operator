defmodule OperatorWeb.PageController do
  use OperatorWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # options: [layout: false]
    render(conn, :home)
  end
end
