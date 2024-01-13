defmodule CraftingWeb.TaskSchedulerJSON do
  alias Crafting.Scheduler.Task

  @doc """
  Renders a list of tasks.
  """
  def create(%{tasks: tasks}) do
    %{tasks: for(task <- tasks, do: data(task))}
  end

  defp data(%Task{} = task) do
    %{
      name: task.name,
      command: task.command
    }
  end
end
