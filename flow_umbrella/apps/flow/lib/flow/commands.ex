# Generated code
defmodule Flow.Story.Commands do
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
      :by
    ]
  end

  defmodule WorkOnStory do
    defstruct [
      :storyId,
      :by
    ]
  end

  defmodule FinishStory do
    defstruct [
      :storyId
    ]
  end
end
