# Generated code
defmodule Flow.Story.Events do
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
      :by
    ]
  end

  defmodule WorkedOnStory do
    defstruct [
      :storyId,
      :by
    ]
  end

  defmodule ProcessStepForStoryFinished do
    defstruct [
      :storyId,
      :by,
      :step
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
