defmodule Mix.Tasks.Flow.GenerateDomain do
  use Mix.Task

  @base_path "./apps/flow/lib/flow"

  def run(_) do
    :ok = Application.start(:yamerl)
    domain = :yamerl_constr.file("../domain.yml")
    parse(domain)
  end

  def parse([[commands, events]]) do
    parse_messages("commands", commands)
    parse_messages("events", events)
  end

  defp parse_messages(type, {module, messages}) when is_list(messages) do
    path = @base_path <> "/" <> type <> ".ex"
    messages = Enum.map(messages, &parse_message/1)

    template = """
    # Generated code
    defmodule <%= @module %> do
        <%= for message <- @messages do %>
            defmodule <%= message.name %> do
                @enforce_keys [
                <%= for attribute <- message.attributes do %>
                    :<%= attribute %>,
                <% end %>
                ]
                defstruct [
                <%= for attribute <- message.attributes do %>
                    :<%= attribute %>,
                <% end %>
                ]
            end
        <% end %>
    end
    """

    output = EEx.eval_string(template, assigns: [module: module, messages: messages])
    :ok = File.write(path, output)
    :ok = Mix.Tasks.Format.run([])
  end

  defp parse_message([{name, attributes}]) when is_list(attributes) do
    attributes = Enum.map(attributes, fn {name, _} -> name end)

    %{
      name: name,
      attributes: attributes
    }
  end
end
