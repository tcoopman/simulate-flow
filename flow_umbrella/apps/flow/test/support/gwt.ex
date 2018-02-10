defmodule Flow.Gwt do
  import Commanded.Assertions.EventAssertions

  alias __MODULE__

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
    gwt = apply_events(gwt)

    module = gwt.aggregate.__struct__
    event = module.execute(gwt.aggregate, gwt.command)

    Enum.each(events, fn e ->
      ^event = e
    end)
  end

  def then_command_fails(%Gwt{} = gwt, failure) do
    gwt = apply_events(gwt)

    module = gwt.aggregate.__struct__
    {:error, ^failure} = module.execute(gwt.aggregate, gwt.command)
  end

  defp apply_events(gwt) do
    aggregate =
      Enum.reduce(gwt.given, gwt.aggregate, fn event, acc ->
        module = acc.__struct__
        module.apply(acc, event)
      end)

    %{gwt | aggregate: aggregate}
  end
end
