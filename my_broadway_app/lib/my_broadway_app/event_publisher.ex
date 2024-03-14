defmodule MyBroadwayApp.EventPublisher do
  use GenServer
  use AMQP

  require Logger

  alias AMQP.Connection

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @exchange "events"

  def init(_opts) do
    case Connection.open("amqp://guest:guest@rabbitmq") do
      {:ok, conn} ->
        IO.puts("Connection to RabbitMQ established successfully.")
        case Channel.open(conn) do
          {:ok, chan} ->
            Logger.info("Channel opened successfully.")
            setup_exchange(chan)
            {:ok, chan}

          {:error, reason} ->
            Logger.error("Failed to open channel: #{inspect(reason)}.")
            {:stop, reason}
        end

      {:error, reason} ->
        IO.puts("Failed to establish connection to RabbitMQ: #{reason}.")
        {:stop, reason}
    end
  end

  defp setup_exchange(chan) do
    Exchange.declare(chan, @exchange, :fanout)
  end

  def publish_event(routing_key, event_payload) do
    GenServer.cast(__MODULE__, {:publish, {routing_key, event_payload}})
  end

  def handle_cast({:publish, {routing_key, payload}}, chan) do
    IO.puts("Roting key! #{inspect(routing_key)}")
    publish(chan, routing_key, payload)

    {:noreply, chan}
  end

  defp publish(chan, routing_key, payload) do
    IO.puts("Publishing event! #{inspect(payload)}")
    IO.puts("Channel! #{inspect(chan)}")
    Basic.publish(chan, @exchange, "", "Hello, World!")
  end
end
