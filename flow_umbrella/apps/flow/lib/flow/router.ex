# Generated code
defmodule Flow.Router do
  use Commanded.Commands.Router

  alias Flow.{
    Board
  }

  alias Flow.Board.Commands.{
    CreateStory,
    PickUpStory,
    WorkOnStory,
    FinishStory
  }

  dispatch(CreateStory, to: Board, identity: :storyId)

  dispatch(PickUpStory, to: Board, identity: :storyId)

  dispatch(WorkOnStory, to: Board, identity: :storyId)

  dispatch(FinishStory, to: Board, identity: :storyId)
end
