defmodule FlowTests.Board do
  use Flow.StorageCase
  import Commanded.Assertions.EventAssertions
  import Flow.Factory

  alias Flow.Router
  alias Flow.Board.Events.{StoryCreated}

  describe "FooBar" do
    test "When nothing is started" do
      command = build(:create_story)

      :ok = Router.dispatch(command)

      assert_receive_event(%StoryCreated{}, fn event ->
        assert true
      end)
    end
  end
end
