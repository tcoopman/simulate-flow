defmodule Flow.Gwt do
  import Commanded.Assertions.EventAssertions

  alias __MODULE__

  alias Flow.Router

  defstruct [:aggregate, :given, :command]

  def given(aggregate, events) when is_list(events) do
    %Gwt{
      aggregate: aggregate,
      given: events
    }
  end

  def when_(%Gwt{} = gwt, command) do
    %{
      gwt
      | command: command
    }
  end

  def then_(%Gwt{} = gwt, events) when is_list(events) do
    aggregate =
      Enum.reduce(gwt.given, gwt.aggregate, fn event, acc ->
        acc.apply(event)
      end)

    :ok = Router.dispatch(gwt.command)

    Enum.each(events, fn event ->
      assert_receive_event(event.__struct__, fn e ->
        event = e
      end)
    end)
  end
end
