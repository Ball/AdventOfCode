defmodule Day08 do
  def load_image(image, width, height) do
    image
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(width * height)
    |> Enum.map(fn layer -> layer |> Enum.chunk_every(width) end)
  end

  def validate_image() do
    {:ok, contents} = File.read("day08_input.txt")
    layer = contents
            |> load_image(25, 6)
            |> Enum.min_by(fn layer -> count_digits(layer, 0) end)
    count_digits(layer, 1) * count_digits(layer, 2)
  end

  def decode_image() do
    {:ok, contents} = File.read("day08_input.txt")
    contents
    |> load_image(25, 6)
    |> merge_image()
    |> Enum.map(fn s -> Enum.join(s, "") end)
    |> Enum.join("\n")
    |> (fn s -> s <> "\n" end).()
  end

  def merge_image(layers) do
    layers
    |> Enum.reduce(&merge_layer/2)
  end

  def merge_layer(layer1, layer2) do
    Enum.zip(layer2, layer1)
    |> Enum.map(&merge_row/1)
  end

  def merge_row({r1, r2}) do
    Enum.zip(r1, r2)
    |> Enum.map(&merge_pixel/1)
  end

  def merge_pixel({a,b}) do
    if a == 2 do
      b
    else
      a
    end
  end

  def count_digits(layer, digit) do
    layer
    |> Enum.concat()
    |> Enum.map(fn e -> if (e == digit), do: 1, else: 0 end)
    |> Enum.sum()
  end
end
