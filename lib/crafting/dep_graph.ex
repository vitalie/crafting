defmodule Crafting.DepGraph do
  @moduledoc """
  This module handles tasks ordering. Each task is represented by a tuple
  {name, deps}, where name is the task name and deps is the list of tasks which
  should be run before it.

  Example:
    {:t1, [:t2, :t3]}
  """

  @type task_name :: binary
  @type task_deps :: list(task_name)
  @type task :: {task_name, task_deps}
  @type task_list :: list(task)

  @doc """
  This function orders tasks by their dependencies using Khan's algorithm for
  topological sorting of a Directed Acyclic Graphs.

    iex> sort([{:t1, [:t2]}, {:t2, []}])
    [:t2, t1]
  """
  @spec sort(task_list) :: {:ok, [task_name, ...]} | {:error, any}
  def sort(tasks),
    do: sort(split(tasks), {length(tasks), []})

  def sort({[], []}, {0, acc}),
    do: {:ok, Enum.reverse(acc)}

  def sort({[{name, _} | tail], tasks}, {n, acc}),
    do: sort({tail, remove_dep(tasks, name)}, {n - 1, [name | acc]})

  def sort({[], tasks}, {n, acc}) do
    case split(tasks) do
      {[], _} ->
        {:error, {:cycle, tasks}}

      {nodeps, tasks} ->
        sort({nodeps, tasks}, {n, acc})
    end
  end

  @doc """
  Splits input tasks into lists of independent tasks and tasks with dependencies.
  """
  @spec split(task_list) :: {task_list, task_list}
  def split(tasks) do
    Enum.split_with(tasks, fn
      {_name, []} -> true
      _ -> false
    end)
  end

  @doc """
  Removes a task from the `name` from tasks dependencies.
  """
  @spec remove_dep(task_list, task_name, task_list) :: task_list
  def remove_dep(tasks, name, acc \\ [])

  def remove_dep([], _name, acc), do: acc
  def remove_dep([{name, []} | tail], name, acc), do: remove_dep(tail, name, acc)
  def remove_dep([t | tail], name, acc), do: remove_dep(tail, name, [remove_t_dep(t, name) | acc])

  defp remove_t_dep(task, name, acc \\ [])
  defp remove_t_dep({name, []}, _name, acc), do: {name, Enum.reverse(acc)}
  defp remove_t_dep({name, [d | tail]}, d, acc), do: remove_t_dep({name, tail}, d, acc)
  defp remove_t_dep({name, [t | tail]}, d, acc), do: remove_t_dep({name, tail}, d, [t | acc])
end
