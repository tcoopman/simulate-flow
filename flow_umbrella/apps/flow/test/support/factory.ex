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
    %CreateStory{}
  end

  def pick_up_story_factory do
    %PickUpStory{}
  end

  def work_on_story_factory do
    %WorkOnStory{}
  end

  def finish_story_factory do
    %FinishStory{}
  end

  def story_created_factory do
    %StoryCreated{}
  end

  def story_picked_up_factory do
    %StoryPickedUp{}
  end

  def worked_on_story_factory do
    %WorkedOnStory{}
  end

  def process_step_for_story_finished_factory do
    %ProcessStepForStoryFinished{}
  end

  def story_finished_factory do
    %StoryFinished{}
  end
end
