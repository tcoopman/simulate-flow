defmodule Mix.Tasks.Flow.GenerateDomain do
  use Mix.Task

  def run(_) do
    :ok = Application.start(:yamerl)
    domain = :yamerl_constr.file("../domain.yml")
    execute("Flow", domain)
    IO.puts("Created new files, commands, events, router and factories are overwritten")

    IO.puts(
      "Aggregates are saved to template, check if you need anything from it and copy paste it"
    )

    IO.puts("Afterwards you can delete the template")
    IO.puts("Please run your test when you are done.")
  end

  def execute(module, [[{aggregate, messages}]]) do
    {'identity', identity} = hd(messages)
    aggregate = to_string(aggregate)

    {commands, events} = map_messages(tl(messages))

    commands_module = module <> "." <> aggregate <> ".Commands"
    events_module = module <> "." <> aggregate <> ".Events"

    commands_template = generate_messages(commands_module, commands)
    events_template = generate_messages(events_module, events)
    router_template = generate_router(module, aggregate, identity, commands_module, commands)

    aggregate_template =
      generate_aggregate(module, aggregate, commands_module, commands, events_module, events)

    factories_template = generate_factories(commands_module, commands, events_module, events)

    commands_path = base_folder(module) <> "/commands.ex"
    events_path = base_folder(module) <> "/events.ex"
    router_path = base_folder(module) <> "/router.ex"
    aggregate_path = base_folder(module) <> "/" <> Macro.underscore(aggregate) <> "_template.ex"
    factories_path = base_test_folder(module) <> "/support/factory.ex"

    :ok = File.write(commands_path, commands_template)
    :ok = File.write(events_path, events_template)
    :ok = File.write(router_path, router_template)
    :ok = File.write(aggregate_path, aggregate_template)
    :ok = File.write(factories_path, factories_template)

    :ok = Mix.Tasks.Format.run([])
  end

  defp base_folder(module) do
    module = Macro.underscore(module)
    folder = "./apps/" <> module <> "/lib/" <> module
    :ok = File.mkdir_p(folder)
    folder
  end

  defp base_test_folder(module) do
    module = Macro.underscore(module)
    folder = "./apps/" <> module <> "/test"
    :ok = File.mkdir_p(folder)
    folder
  end

  defp map_messages([{'Commands', commands}, {'Events', events}]) do
    commands = Enum.map(commands, &parse_command/1)
    events = Enum.map(events, &parse_event/1)
    {commands, events}
  end

  defp parse_command([
         {name, [{'attributes', attributes}, {'happyPath', event}]}
       ])
       when is_list(attributes) do
    attributes = Enum.map(attributes, &parse_attributes/1)

    %{
      name: name,
      underscore_name: to_underscore(name),
      attributes: attributes,
      happyPath: event
    }
  end

  defp parse_event([
         {name, [{'attributes', attributes}]}
       ])
       when is_list(attributes) do
    attributes = Enum.map(attributes, &parse_attributes/1)

    %{
      name: name,
      underscore_name: to_underscore(name),
      attributes: attributes
    }
  end

  defp parse_attributes({name, example}),
    do: %{
      name: name,
      example: example
    }

  defp generate_messages(module, messages) do
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

    EEx.eval_string(template, assigns: [module: module, messages: messages])
  end

  defp generate_router(module, aggregate, identity, commands_module, commands) do
    template = """
    # Generated code
    defmodule <%= @module %>.Router do
        use Commanded.Commands.Router

        alias <%= @module %>.<%= @aggregate %>
        <%= @command_aliasses %>

        identify <%= @aggregate %>,
          by: :<%= @identity %>,
          prefix: "<%= Macro.underscore(@aggregate) %>_"

        <%= for command <- @commands do %>
            dispatch <%= command.name %>, to: <%= @aggregate %>
        <% end %>
    end
    """

    EEx.eval_string(
      template,
      assigns: [
        module: module,
        identity: identity,
        commands: commands,
        aggregate: aggregate,
        command_aliasses: generate_aliasses(commands_module, commands)
      ]
    )
  end

  defp generate_aggregate(module, aggregate, commands_module, commands, events_module, events) do
    template = """
    # Generated code
    defmodule <%= @module %>.<%= @aggregate %> do
      defstruct []

      alias __MODULE__
      <%= @commands_aliasses %>
      <%= @events_aliasses %>

      <%= @execute_functions %>

      <%= for event <- @events do %>
      def apply(%<%= @aggregate %>{} = <%= @aggregate_lower %>, %<%= event.name %>{}) do
        <%= @aggregate_lower %>
      end
      <% end %>
    end
    """

    EEx.eval_string(
      template,
      assigns: [
        module: module,
        aggregate: aggregate,
        aggregate_lower: Macro.underscore(aggregate),
        execute_functions: generate_execute_functions(aggregate, commands),
        events: events,
        commands_aliasses: generate_aliasses(commands_module, commands),
        events_aliasses: generate_aliasses(events_module, events)
      ]
    )
  end

  defp generate_execute_functions(aggregate, commands) do
    template = """
      <%= for command <- @commands do %>
      def execute(%<%= @aggregate %>{}, %<%= command.name %>{
        <%= for attribute <- command.attributes do %>
          <%= attribute.name %>: <%= attribute.name %>,
        <% end %>
      }) do
        %<%= command.happyPath %>{
        <%= for attribute <- command.attributes do %>
          <%= attribute.name %>: <%= attribute.name %>,
        <% end %>
        }
      end
      <% end %>
    """

    EEx.eval_string(
      template,
      assigns: [
        aggregate: aggregate,
        commands: commands
      ]
    )
  end

  defp generate_factories(commands_module, commands, events_module, events) do
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

    EEx.eval_string(
      template,
      assigns: [
        commands: generate_message_factories(commands),
        events: generate_message_factories(events),
        commands_aliasses: generate_aliasses(commands_module, commands),
        events_aliasses: generate_aliasses(events_module, events)
      ]
    )
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
                    <%= for attribute <- message.attributes do %>
                        <%= attribute.name %>: "<%= attribute.example %>",
                    <% end %>
                }
            end
        <% end %>
    """

    EEx.eval_string(template, assigns: [messages: messages])
  end
end
