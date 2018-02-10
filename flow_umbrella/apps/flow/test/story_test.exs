defmodule FlowTests.Story do
  use Flow.StorageCase
  import Commanded.Assertions.EventAssertions
  import Flow.Factory

  alias Flow.Router
  alias Flow.Gwt
  alias Flow.Story
  alias Flow.Story.Events.{StoryCreated}

  describe "Story" do
    test "When nothing is started" do
      Gwt.given(%Story{}, [])
      |> Gwt.when_(build(:create_story))
      |> Gwt.then_([build(:story_created)])
    end

    test "Cannot do anything on an unstarted story" do
      Gwt.given(%Story{}, [])
      |> Gwt.when_(build(:pick_up_story))
      |> Gwt.then_command_fails(:story_does_not_exist)
    end

    test "A happy flow path story finished" do
      Gwt.given(%Story{}, [
        build(:story_created)
      ])
      |> Gwt.when_(build(:pick_up_story))
      |> Gwt.then_([build(:story_picked_up)])
    end
  end
end
