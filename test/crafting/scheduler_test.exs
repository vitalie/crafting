defmodule Crafting.SchedulerTest do
  use Crafting.DataCase

  alias Crafting.Scheduler
  alias Crafting.Scheduler.Task

  describe "tasks" do
    @valid_attrs [
      %{
        name: "t1",
        command: "touch /tmp/file1"
      },
      %{
        name: "t2",
        command: "cat /tmp/file1",
        requires: ~w(t3)
      },
      %{
        name: "t3",
        command: ~s"echo 'Hello, world!' > /tmp/file1",
        requires: ~w(t1)
      },
      %{
        name: "t4",
        command: ~s"rm  /tmp/file1",
        requires: ~w(t2 t3)
      }
    ]

    @invalid_attrs [
      %{
        name: "t1",
        command: "whoami",
        requires: ~w(t2)
      },
      %{
        name: "t2",
        command: "whoami",
        requires: ~w(t1)
      }
    ]

    test "schedule/1 with valid data returns ordered tasks" do
      assert {:ok,
              [
                %Task{command: "touch /tmp/file1", name: "t1", requires: []},
                %Task{
                  command: "echo 'Hello, world!' > /tmp/file1",
                  name: "t3",
                  requires: ["t1"]
                },
                %Task{command: "cat /tmp/file1", name: "t2", requires: ["t3"]},
                %Task{
                  command: "rm  /tmp/file1",
                  name: "t4",
                  requires: ["t2", "t3"]
                }
              ]} = Scheduler.schedule(@valid_attrs)
    end

    test "schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Scheduler.schedule(@invalid_attrs)
      assert "cycle detected in t1, t2" in errors_on(changeset).tasks
    end
  end
end
