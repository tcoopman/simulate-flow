# Generated code
defmodule Flow.Factory do
  use ExMachina

  alias Flow.Story.Commands.{
    CreateStory,
    PickUpStory,
    WorkOnStory,
    FinishStory
  }

  alias Flow.Story.Events.{
    StoryCreated,
    StoryPickedUp,
    WorkedOnStory,
    ProcessStepForStoryFinished,
    StoryFinished
  }

  def create_story_factory do
    %CreateStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "Work on flow simulator",
      work: "null"
    }
  end

  def pick_up_story_factory do
    %PickUpStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      by: "Thomas",
      work: "null"
    }
  end

  def work_on_story_factory do
    %WorkOnStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907"
    }
  end

  def finish_story_factory do
    %FinishStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907"
    }
  end

  def story_created_factory do
    %StoryCreated{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "Work on flow simulator",
      work: "null"
    }
  end

  def story_picked_up_factory do
    %StoryPickedUp{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      by: "Thomas",
      work: "null"
    }
  end

  def worked_on_story_factory do
    %WorkedOnStory{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "string",
      work: "null"
    }
  end

  def process_step_for_story_finished_factory do
    %ProcessStepForStoryFinished{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "string",
      work: "null"
    }
  end

  def story_finished_factory do
    %StoryFinished{
      storyId: "d7b86407-bad3-4eac-b1d1-0209d5276907",
      name: "string",
      work: "null"
    }
  end
end
