# Generated code
defmodule Flow.Story do
  defstruct [:storyId, :picked_up_by]

  alias __MODULE__

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

  def execute(%Story{storyId: nil}, %CreateStory{
        storyId: storyId,
        name: name,
        work: work
      }) do
    %StoryCreated{
      storyId: storyId,
      name: name,
      work: work
    }
  end

  def execute(%Story{storyId: nil}, %PickUpStory{}) do
    {:error, :story_does_not_exist}
  end

  def execute(%Story{}, %PickUpStory{
        storyId: storyId,
        by: by,
      }) do
    %StoryPickedUp{
      storyId: storyId,
      by: by,
    }
  end

  def execute(%Story{storyId: nil}, %WorkOnStory{}) do
    {:error, :story_does_not_exist}
  end

  def execute(%Story{picked_up_by: nil}, %WorkOnStory{}) do
    {:error, :story_not_picked_up}
  end

  def execute(%Story{}, %WorkOnStory{
        storyId: storyId,
        by: by
      }) do
    %WorkedOnStory{
      storyId: storyId,
      by: by
    }
  end

  def execute(%Story{storyId: nil}, %FinishStory{}) do
    {:error, :story_does_not_exist}
  end

  def execute(%Story{}, %FinishStory{
        storyId: storyId
      }) do
    %StoryFinished{
      storyId: storyId
    }
  end

  def apply(%Story{} = story, %StoryCreated{storyId: storyId}) do
    %{story | storyId: storyId}
  end

  def apply(%Story{} = story, %StoryPickedUp{by: by}) do
    %{story | picked_up_by: by}
  end

  def apply(%Story{} = story, %WorkedOnStory{}) do
    story
  end

  def apply(%Story{} = story, %ProcessStepForStoryFinished{}) do
    story
  end

  def apply(%Story{} = story, %StoryFinished{}) do
    story
  end
end
