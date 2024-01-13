defmodule CraftingWeb.TaskSchedulerController do
  use CraftingWeb, :controller

  alias Crafting.Scheduler

  action_fallback CraftingWeb.FallbackController

  def create(conn, %{"tasks" => tasks_params}) do
    with {:ok, tasks} <- Scheduler.schedule(tasks_params) do
      conn
      |> put_status(:created)
      |> render(:create, tasks: tasks)
    end
  end
end
