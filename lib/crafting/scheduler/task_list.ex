defmodule Crafting.Scheduler.TaskList do
  use Ecto.Schema

  import Ecto.Changeset
  alias Crafting.Scheduler.Task

  @primary_key false
  embedded_schema do
    embeds_many :tasks, Task
  end

  @doc false
  def changeset(task_list, attrs) do
    task_list
    |> cast(%{"tasks" => attrs}, [])
    |> cast_embed(:tasks, with: &Task.changeset/2)
  end
end
