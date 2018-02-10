use Mix.Config

config :commanded,
  dispatch_consistency_timeout: 100,
  event_store_adapter: Commanded.EventStore.Adapters.InMemory,
  reset_storage: fn ->
    {:ok, _event_store} = Commanded.EventStore.Adapters.InMemory.start_link()
  end
