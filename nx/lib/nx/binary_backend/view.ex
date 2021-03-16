defmodule Nx.BinaryBackend.View do
  alias Nx.BinaryBackend.View
  alias Nx.BinaryBackend.WeightedShape
  alias Nx.BinaryBackend.Traverser

  defstruct weighted_shape: nil,
            type: nil,
            changed?: false

  def build(shape) do
    %View{
      weighted_shape: WeightedShape.build(shape)
    }
  end

  def must_be_resolved?(%View{weighted_shape: {_, _, _}}), do: true
  def must_be_resolved?(_), do: false

  def has_changes?(%View{changed?: c}), do: c

  def aggregate(view, axes) do
    change(view, fn ws -> WeightedShape.aggregate(ws, axes) end)
  end

  def transpose(view, axes) do
    change(view, fn ws -> WeightedShape.transpose(ws, axes) end)
  end

  def reverse(view, axes) do
    change(view, fn ws -> WeightedShape.reverse(ws, axes) end)
  end

  def dilate(view, dilation) do
    change(view, fn ws -> WeightedShape.dilate(ws, dilation) end)
  end

  def limit(view, limits) do
    change(view, fn ws -> WeightedShape.limit(ws, limits) end)
  end

  def with_type(view, type) do
    %View{view | type: type}
  end

  defp change(%View{weighted_shape: ws} = view, fun) when is_list(ws) do
    %View{view | weighted_shape: fun.(ws), changed?: true}
  end

  def build_traverser(%View{weighted_shape: ws, type: {_, _} = type}) do
    Traverser.build(ws, type)
  end

  def build_traverser(%View{weighted_shape: ws, type: nil}) do
    Traverser.build(ws)
  end
end
