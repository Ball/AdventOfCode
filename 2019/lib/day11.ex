defmodule Day11 do
  def painted_pannels(pre_painted \\ []) do
    {:ok, content} = File.read("day11_input.txt")

    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Day11.PaintRobot.with_program(pre_painted)
  end

  def insignia() do
    paint_trail = painted_pannels([{1, {0, 0}}]) |> Enum.reverse()
    width = paint_trail |> Enum.map(fn {_, {x, _}} -> x end) |> Enum.max()
    height = paint_trail |> Enum.map(fn {_, {_, y}} -> y end) |> Enum.max()
    surface = List.duplicate(".", width + 1) |> List.duplicate(height + 1)

    paint_trail
    |> Enum.reduce(surface, &paint_surface/2)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  def paint_surface({0, {x, y}}, surface) do
    paint_surface(".", {x, y}, surface)
  end

  def paint_surface({1, {x, y}}, surface) do
    paint_surface("#", {x, y}, surface)
  end

  def paint_surface(color, {x, y}, surface) do
    surface
    |> List.replace_at(y, surface |> Enum.at(y) |> List.replace_at(x, color))
  end

  defmodule PaintRobot do
    defstruct [:computer, :cpu_pid, :parent, :heading, :location, :painted]

    def with_program(program, pre_painted \\ []) do
      robot = %PaintRobot{
        computer: IntcodeComputer.new(program),
        painted: pre_painted,
        location: {0, 0},
        heading: :up,
        parent: self()
      }

      spawn(fn -> run(robot) end)

      receive do
        {:painted, painted} ->
          painted
      end
    end

    def run(robot) do
      rbt = self()
      cpu_pid = spawn(fn -> IntcodeComputer.execute(%{robot.computer | output: rbt}) end)
      wait_for_color(%{robot | cpu_pid: cpu_pid})
    end

    def report(robot) do
      send(robot.parent, {:painted, robot.painted})
    end

    def wait_for_color(robot) do
      robot
      |> look()

      receive do
        {:output, value} ->
          robot
          |> paint(value)
          |> wait_for_turn()

        {:end, _} ->
          report(robot)
      end
    end

    def look(robot) do
      robot.painted
      |> Enum.find({0, robot.location}, fn {_, location} -> robot.location == location end)
      |> elem(0)
      |> (fn color -> send(robot.cpu_pid, {:input, color}) end).()

      robot
    end

    def wait_for_turn(robot) do
      receive do
        {:output, value} ->
          robot
          |> turn(value)
          |> move()
          |> wait_for_color()

        {:end, _} ->
          report(robot)
      end
    end

    def move(robot) do
      case {robot.heading, robot.location} do
        {:up, {x, y}} ->
          %{robot | location: {x, y - 1}}

        {:down, {x, y}} ->
          %{robot | location: {x, y + 1}}

        {:left, {x, y}} ->
          %{robot | location: {x - 1, y}}

        {:right, {x, y}} ->
          %{robot | location: {x + 1, y}}
      end
    end

    def turn(robot, value) do
      case {robot.heading, value} do
        {:up, 0} ->
          %{robot | heading: :left}

        {:up, 1} ->
          %{robot | heading: :right}

        {:left, 0} ->
          %{robot | heading: :down}

        {:left, 1} ->
          %{robot | heading: :up}

        {:right, 0} ->
          %{robot | heading: :up}

        {:right, 1} ->
          %{robot | heading: :down}

        {:down, 0} ->
          %{robot | heading: :right}

        {:down, 1} ->
          %{robot | heading: :left}
      end
    end

    def paint(robot, value) do
      %{robot | painted: [{value, robot.location} | robot.painted]}
    end
  end
end
