# Generated code
defmodule Flow.Factory do
  use ExMachina

  alias Flow.Board.Commands.{
    CreateStory,
    PickUpStory,
    WorkOnStory,
    FinishStory
  }

  alias Flow.Board.Events.{
    StoryCreated,
    StoryPickedUp,
    WorkedOnStory,
    ProcessStepForStoryFinished,
    StoryFinished
  }

  def create_story_factory do
    %CreateStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "string",
      work: "null"
    }
  end

  def pick_up_story_factory do
    %PickUpStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "string",
      work: "null"
    }
  end

  def work_on_story_factory do
    %WorkOnStory{
      storyId: "string"
    }
  end

  def finish_story_factory do
    %FinishStory{
      storyId: "string"
    }
  end

  def create_story_factory do
    %CreateStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "string",
      work: "null"
    }
  end

  def pick_up_story_factory do
    %PickUpStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "string",
      work: "null"
    }
  end

  def work_on_story_factory do
    %WorkOnStory{
      storyId: "string"
    }
  end

  def finish_story_factory do
    %FinishStory{
      storyId: "string"
    }
  end
end
