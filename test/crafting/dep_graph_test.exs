defmodule Crafting.DepGraphTest do
  use ExUnit.Case, async: true

  alias Crafting.DepGraph

  describe "sort/1" do
    test "returns empty list when no tasks are supplied" do
      assert {:ok, []} = DepGraph.sort([])
    end

    test "returns sorted tasks by dependencies" do
      assert {:ok, [:t1]} = DepGraph.sort([{:t1, []}])
      assert {:ok, [:t1, :t2]} = DepGraph.sort([{:t1, []}, {:t2, []}])
      assert {:ok, [:t2, :t1]} = DepGraph.sort([{:t1, [:t2]}, {:t2, []}])

      assert {:ok, [:t1, :t3, :t2, :t4]} =
               DepGraph.sort([
                 {:t1, []},
                 {:t2, [:t3]},
                 {:t3, [:t1]},
                 {:t4, [:t2, :t3]}
               ])
    end

    test "returns error when at least on cycle is detects" do
      assert {:error, {:cycle, _}} = DepGraph.sort([{:t1, [:t2]}, {:t2, [:t1]}])
      assert {:error, {:cycle, _}} = DepGraph.sort([{:t1, [:t2]}, {:t2, [:t3]}, {:t3, :t1}])
    end
  end

  describe "split/1" do
    test "returns empty list when no tasks are supplied" do
      assert {[], []} = DepGraph.split([])
    end

    test "returns a tuple with independent tasks and remaining tasks" do
      assert {[{:t1, []}], []} = DepGraph.split([{:t1, []}])
      assert {[], [{:t1, [:t2]}]} = DepGraph.split([{:t1, [:t2]}])
      assert {[{:t1, []}], [{:t2, [:t1]}]} = DepGraph.split([{:t1, []}, {:t2, [:t1]}])
    end
  end

  describe "remove_dep/2" do
    test "returns original deps when dependency is not found" do
      assert [{:t1, []}] = DepGraph.remove_dep([{:t1, []}], :t2)
      assert [{:t1, [:t1]}] = DepGraph.remove_dep([{:t1, [:t1]}], :t2)
    end

    test "removes a dependency from the deps" do
      assert [{:t1, [:t1]}] = DepGraph.remove_dep([{:t1, [:t1, :t2]}], :t2)
    end

    test "removes a dependency from the deps, including duplicates" do
      assert [{:t1, []}] = DepGraph.remove_dep([{:t1, [:t2, :t2]}], :t2)
      assert [{:t1, [:t1]}] = DepGraph.remove_dep([{:t1, [:t1, :t2, :t2]}], :t2)
    end
  end
end
