defmodule CraftingWeb.TaskSchedulerControllerTest do
  use CraftingWeb.ConnCase

  # import Crafting.SchedulerFixtures

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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "renders tasks when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks/schedule", tasks: @valid_attrs)
      assert json_response(conn, 201)

      assert [
               %{"name" => "t1", "command" => "touch /tmp/file1"},
               %{"name" => "t3", "command" => ~s"echo 'Hello, world!' > /tmp/file1"},
               %{"name" => "t2", "command" => "cat /tmp/file1"},
               %{"name" => "t4", "command" => ~s"rm  /tmp/file1"}
             ] = json_response(conn, 201)["tasks"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks/schedule", tasks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
