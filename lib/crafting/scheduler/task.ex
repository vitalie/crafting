defmodule Crafting.Scheduler.Task do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :command, :string
    field :name, :string
    field :requires, {:array, :string}, default: []
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :command, :requires])
    |> validate_required([:name, :command])
  end
end
