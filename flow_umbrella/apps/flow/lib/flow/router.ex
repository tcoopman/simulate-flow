# Generated code
defmodule Flow.Router do
  use Commanded.Commands.Router

  alias Flow.Story

  alias Flow.Story.Commands.{
    CreateStory,
    PickUpStory,
    WorkOnStory,
    FinishStory
  }

  identify(
    Story,
    by: :storyId,
    prefix: "story_"
  )

  dispatch(CreateStory, to: Story)

  dispatch(PickUpStory, to: Story)

  dispatch(WorkOnStory, to: Story)

  dispatch(FinishStory, to: Story)
end
