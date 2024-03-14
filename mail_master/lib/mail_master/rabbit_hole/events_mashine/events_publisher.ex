defmodule MailMaster.RabbitHole.EventsMashine.EventsPublisher do
  use GenServer
  use AMQP

  require Logger

  alias MailMaster.RabbitHole.EventsMashine.EventsGenerator

  @exchange_name "events"
  @queue_name "events_queue"

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, conn} = Connection.open("amqp://guest:guest@rabbitmq")
    {:ok, channel} = Channel.open(conn)

    Exchange.declare(channel, @exchange_name, :fanout)

    Queue.declare(channel, @queue_name)

    Queue.bind(channel, @queue_name, @exchange_name)

    :timer.send_interval(10000, :publish_events)

    {:ok, %{connection: conn, channel: channel}}
  end

  def handle_info(:publish_events, %{connection: conn, channel: channel} = state) do
    events = EventsGenerator.generate_events(50000)

    publish_events(channel, events)

    {:noreply, state}
  end

  defp publish_events(channel, events) do
    Enum.each(events, fn event ->
      Logger.info("Publishing event! #{inspect(event)}")
      Basic.publish(channel, @exchange_name, "", Jason.encode!(event))
    end)

    {:ok, channel}
  end
end
