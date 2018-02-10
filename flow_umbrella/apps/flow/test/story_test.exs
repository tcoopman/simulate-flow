defmodule FlowTests.Story do
  use Flow.StorageCase
  import Commanded.Assertions.EventAssertions
  import Flow.Factory

  alias Flow.Router
  alias Flow.Gwt
  alias Flow.Story.Events.{StoryCreated}

  describe "Story" do
    test "When nothing is started" do
      Gwt.given(Flow.Story, [])
      |> Gwt.when_(build(:create_story))
      |> Gwt.then_([build(:story_created)])
    end
  end
end
