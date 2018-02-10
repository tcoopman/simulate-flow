# Generated code
defmodule Flow.Board.Events do
  defmodule StoryCreated do
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end

  defmodule StoryPickedUp do
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end

  defmodule WorkedOnStory do
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end

  defmodule ProcessStepForStoryFinished do
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end

  defmodule StoryFinished do
    defstruct [
      :storyId,
      :name,
      :work
    ]
  end
end
