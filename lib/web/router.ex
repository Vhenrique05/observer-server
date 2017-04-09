defmodule Web.Router do
  use Plug.Router

  plug Plug.Static, at: "/", from: :web_socket

  plug :match
  plug :dispatch

  get "/" do
    data = "public/dist/index.html"
           |> Path.expand
           |> File.read!
    conn |> send_resp(200, data)
  end

  match _ do
    conn |> send_resp(404, "Not Found")
  end
end
