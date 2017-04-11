defmodule Web.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Web.Worker.start_link(arg1, arg2, arg3)
      worker(Web.Tcp, []),
      supervisor(Registry, [:unique, Registry.Sockets]),
      Plug.Adapters.Cowboy.child_spec(:http, Web.Router, [], [
                                      port: Application.get_env(:web, :web_port),
                                      dispatch: dispatch
                                    ])
    ]


    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Web.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_, [
          {"/ws", Web.Handlers.Dashboard, []},
          {:_, Plug.Adapters.Cowboy.Handler, {Web.Router, []}}
        ]}
    ]
  end
end
