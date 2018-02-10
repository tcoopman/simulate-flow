defmodule Flow.StorageCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  require Logger

  setup do
    Application.stop(:commanded)
    Application.stop(:flow)
    Application.stop(:flow_web)

    reset_storage()

    {:ok, _} = Application.ensure_all_started(:commanded)
    # IO.inspect "start motivate me web"
    {:ok, _} = Application.ensure_all_started(:flow)
    {:ok, _} = Application.ensure_all_started(:flow_web)
    :ok
  end

  defp reset_storage do
    case Application.get_env(:commanded, :reset_storage) do
      nil -> :ok
      reset -> reset.()
    end
  end
end
