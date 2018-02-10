defmodule FlowTests.Story do
  use Flow.StorageCase
  import Flow.Factory

  alias Flow.Gwt
  alias Flow.Story

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

      Gwt.given(%Story{}, [])
      |> Gwt.when_(build(:work_on_story))
      |> Gwt.then_command_fails(:story_does_not_exist)

      Gwt.given(%Story{}, [])
      |> Gwt.when_(build(:finish_story))
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
