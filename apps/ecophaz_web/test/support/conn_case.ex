defmodule EcophazWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  import Ecophaz.Factory
  alias EcophazWeb.Services.Authenticator
  alias Plug.Conn

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias EcophazWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint EcophazWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Ecophaz.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Ecophaz.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    if tags[:logged_in] do
      user = insert(:user)
      {:ok, token} = Authenticator.sign_in(user.email, "Azerty12")

      conn =
        conn
        |> Conn.assign(:signed_user, user)
        |> Conn.put_req_header("authorization", "Bearer #{token.token}")

      {:ok, conn: conn, user: user, token: token}
    else
      {:ok, conn: conn}
    end
  end
end
