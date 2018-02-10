# Generated code
defmodule Flow.Board.Commands do
  defmodule CreateStory do
    @enforce_keys [
      :storyId,
      :name,
      :work
    ]
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end

  defmodule PickUpStory do
    @enforce_keys [
      :storyId
    ]
    defstruct [
      :storyId
    ]
  end

  defmodule WorkOnStory do
    @enforce_keys [
      :storyId
    ]
    defstruct [
      :storyId
    ]
  end

  defmodule FinishStory do
    @enforce_keys [
      :storyId
    ]
    defstruct [
      :storyId
    ]
  end
end
