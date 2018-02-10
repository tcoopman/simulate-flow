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
    generate_router(commands_module, commands)
    generate_aggregate("board", commands_module, commands, events_module, events)
    generate_factories(commands_module, commands, events_module, events)
    :ok = Mix.Tasks.Format.run([])
  end

  defp parse_message([
         {name, [{'attributes', attributes}, {'aggregate', aggregate}, {'identity', identity}]}
       ])
       when is_list(attributes) do
    attributes = Enum.map(attributes, &parse_attributes/1)

    %{
      name: name,
      underscore_name: to_underscore(name),
      attributes: attributes,
      aggregate: aggregate,
      identity: identity
    }
  end

  defp parse_attributes({name, example}),
    do: %{
      name: name,
      example: example
    }

  defp generate_messages(type, module, messages) do
    path = @base_path <> "/" <> type <> ".ex"

    template = """
    # Generated code
    defmodule <%= @module %> do
        <%= for message <- @messages do %>
            defmodule <%= message.name %> do
                defstruct [
                <%= for attribute <- message.attributes do %>
                    :<%= attribute.name %>,
                <% end %>
                ]
            end
        <% end %>
    end
    """

    output = EEx.eval_string(template, assigns: [module: module, messages: messages])
    :ok = File.write(path, output)
  end

  defp generate_router(commands_module, commands) do
    path = @base_path <> "/router.ex"

    template = """
    # Generated code
    defmodule Flow.Router do
        use Commanded.Commands.Router

        alias Flow.{
            <%= for aggregate <- @aggregates do %>
                <%= aggregate %>
            <% end %>
        }
        <%= @command_aliasses %>

        <%= for command <- @commands do %>
            dispatch <%= command.name %>, to: <%= command.aggregate %>, identity: :<%= command.identity %>
        <% end %>
    end
    """

    aggregates =
      Enum.map(commands, fn command ->
        command.aggregate
      end)
      |> Enum.dedup()

    output =
      EEx.eval_string(
        template,
        assigns: [
          commands: commands,
          aggregates: aggregates,
          command_aliasses: generate_aliasses(commands_module, commands)
        ]
      )

    :ok = File.write(path, output)
  end

  defp generate_aggregate(aggregate, commands_module, commands, events_module, events) do
    path = @base_path <> "/" <> aggregate <> ".ex"

    template = """
    # Generated code
    defmodule Flow.<%= @aggregate %> do
      defstruct []

      def execute(_, _) do
      end
    end
    """

    output =
      EEx.eval_string(
        template,
        assigns: [
          aggregate: Macro.camelize(aggregate)
        ]
      )

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
          events: generate_message_factories(events),
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
