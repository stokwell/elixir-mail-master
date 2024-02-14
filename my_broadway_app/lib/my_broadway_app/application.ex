defmodule MyBroadwayApp.Application do
  use Application

  # MyBroadwayApp.Application.start(:normal, [])

  def start(_type, _args) do
    children = [
      MyBroadwayApp.UserStorage
    ]

    opts = [strategy: :one_for_one, name: MyBroadwayApp.Supervisor]
    Supervisor.start_link(children, opts)

    get_or_generate_users() |> publish_events()

    {:ok, nil}
  end


  defp get_or_generate_users do
    if MyBroadwayApp.UserStorage.get_all_users() == [] do
      IO.puts("Generating new users...")
      generate_new_users()
    else
      IO.puts("Users already generated.")
    end

    MyBroadwayApp.UserStorage.get_all_users()
  end

  def generate_new_users do
    for _ <- 1..50 do
      id = :crypto.strong_rand_bytes(8) |> Base.encode16()
      first_name = Faker.Person.first_name()
      last_name = Faker.Person.last_name()
      email = "#{String.downcase(first_name)}_#{String.downcase(last_name)}@example.com"
      balance = 0
      MyBroadwayApp.UserStorage.add_user(id, email, balance)
    end
  end

  defp publish_events(users) do
    # Run event handling tasks concurrently
    Enum.each(1..120, fn _ ->
      Task.async(fn ->
        random_user = Enum.random(users)
        event = random_event(random_user.id)
        IO.puts("User #{random_user.id} generated event: #{inspect(event)}")
        MyBroadwayApp.EventHandler.handle_event(event)
      end)
    end)
    |> Enum.map(&Task.await/1)

    IO.puts("Random events for 100 random users were published.")

    {:ok, nil}
  end


  defp random_event(user_id) do
    events = [
      %MyBroadwayApp.Events.FinishingMeditation{user_id: user_id},
      %MyBroadwayApp.Events.FinishingIntro{user_id: user_id},
      %MyBroadwayApp.Events.FinishingCourse{user_id: user_id}
    ]
    Enum.random(events)
  end
end
