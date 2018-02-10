# Generated code
defmodule Flow.Board.Events do
  defmodule StoryCreated do
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

  defmodule StoryPickedUp do
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

  defmodule WorkedOnStory do
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

  defmodule ProcessStepForStoryFinished do
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

  defmodule StoryFinished do
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
end
