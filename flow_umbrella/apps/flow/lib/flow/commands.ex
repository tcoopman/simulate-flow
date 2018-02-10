# Generated code
defmodule Flow.Board.Commands do
  defmodule CreateStory do
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end

  defmodule PickUpStory do
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end

  defmodule WorkOnStory do
    defstruct [
      :storyId
    ]
  end

  defmodule FinishStory do
    defstruct [
      :storyId
    ]
  end
end
