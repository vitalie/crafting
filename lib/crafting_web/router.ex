defmodule CraftingWeb.Router do
  use CraftingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CraftingWeb do
    pipe_through :api

    scope "/tasks" do
      resources "/schedule", TaskSchedulerController, only: [:create]
    end
  end
end
