defmodule Crafting.Scheduler do
  @moduledoc """
  The Scheduler context.
  """

  import Ecto.Query, warn: false
  # alias Crafting.Repo

  alias Crafting.DepGraph
  alias Crafting.Scheduler.TaskList

  @doc """
  Creates a task.

  ## Examples

      iex> schedule(%{field: value})
      {:ok, %Task{}}

      iex> schedule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def schedule(attrs \\ %{}) do
    %TaskList{}
    |> TaskList.changeset(attrs)
    |> Map.put(:action, :save)
    |> case do
      %Ecto.Changeset{valid?: true} = changeset ->
        with request <- Ecto.Changeset.apply_changes(changeset),
             tasks_map <- for(t <- request.tasks, into: %{}, do: {t.name, t}),
             tasks <- Enum.map(request.tasks, fn task -> {task.name, task.requires} end),
             {:ok, sorted_names} <- DepGraph.sort(tasks) do
          {:ok, Enum.map(sorted_names, &tasks_map[&1])}
        else
          {:error, {:cycle, cyclic_tasks}} ->
            message = "cycle detected in #{Enum.join(cyclic_tasks, ", ")}"
            {:error, Ecto.Changeset.add_error(changeset, :tasks, message)}
        end

      changeset ->
        {:error, changeset}
    end
  end
end
