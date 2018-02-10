defmodule Mix.Tasks.Flow.GenerateDomain do
  use Mix.Task

  alias __MODULE__

  @base_path "./apps/flow/lib/flow"
  @base_test_path "./apps/flow/test"

  def run(_) do
    :ok = Application.start(:yamerl)
    domain = :yamerl_constr.file("../domain.yml")
    parse(domain)
  end

  def parse([[{commands_module, commands}, {events_module, events}]]) do
    commands = Enum.map(commands, &parse_message/1)
    events = Enum.map(events, &parse_message/1)

    generate_messages("commands", commands_module, commands)
    generate_messages("events", events_module, events)
    generate_factories(commands_module, commands, events_module, events)
    :ok = Mix.Tasks.Format.run([])
  end

  defp parse_message([{name, [{'attributes', attributes}, {'aggregate', aggregate}]}])
       when is_list(attributes) do
    attributes = Enum.map(attributes, fn {name, example} -> {name, example} end)

    %{
      name: name,
      underscore_name: to_underscore(name),
      attributes: attributes,
      aggregate: aggregate
    }
  end

  defp generate_messages(type, module, messages) do
    path = @base_path <> "/" <> type <> ".ex"

    template = """
    # Generated code
    defmodule <%= @module %> do
        <%= for message <- @messages do %>
            defmodule <%= message.name %> do
                @enforce_keys [
                <%= for {attribute,_} <- message.attributes do %>
                    :<%= attribute %>,
                <% end %>
                ]
                defstruct [
                <%= for {attribute,_} <- message.attributes do %>
                    :<%= attribute %>,
                <% end %>
                ]
            end
        <% end %>
    end
    """

    output = EEx.eval_string(template, assigns: [module: module, messages: messages])
    :ok = File.write(path, output)
  end

  defp generate_factories(commands_module, commands, events_module, events) do
    folder = @base_test_path <> "/support/"
    :ok = File.mkdir_p(folder)
    path = folder <> "factory.ex"

    template = """
    # Generated code
    defmodule Flow.Factory do
        use ExMachina

        <%= @commands_aliasses %>
        <%= @events_aliasses %>

        <%= @commands %>
        <%= @events %>
    end
    """

    output =
      EEx.eval_string(
        template,
        assigns: [
          commands: generate_message_factories(commands),
          events: generate_message_factories(commands),
          commands_aliasses: generate_aliasses(commands_module, commands),
          events_aliasses: generate_aliasses(events_module, events)
        ]
      )

    :ok = File.write(path, output)
  end

  defp to_underscore(name) when is_list(name) do
    name
    |> to_string
    |> Macro.underscore()
  end

  defp generate_aliasses(module, messages) do
    template = """
        alias <%= @module %>.{
            <%= for message <- @messages do %>
                <%= message.name %>,
            <% end %>
        }
    """

    EEx.eval_string(template, assigns: [messages: messages, module: module])
  end

  defp generate_message_factories(messages) do
    template = """
        <%= for message <- @messages do %>
            def <%= message.underscore_name %>_factory do
                %<%= message.name %>{
                    <%= for {attribute, example} <- message.attributes do %>
                        <%= attribute %>: "<%= example %>",
                    <% end %>
                }
            end
        <% end %>
    """

    EEx.eval_string(template, assigns: [messages: messages])
  end
end
