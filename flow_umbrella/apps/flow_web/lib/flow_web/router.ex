defmodule FlowWeb.Router do
  use FlowWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", FlowWeb do
    pipe_through(:api)
  end
end
