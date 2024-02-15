defmodule MyBroadwayApp.Application do
  use Application
  require Logger

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
    users = MyBroadwayApp.UserStorage.get_all_users()

    if users == [] do
      Logger.info("Generating new users...")
      generate_new_users()
      ^users = MyBroadwayApp.UserStorage.get_all_users()
    else
      Logger.info("Users already generated.")
    end

    users
  end

  defp generate_new_users do
    Enum.each(1..50, fn _ ->
      id = :crypto.strong_rand_bytes(8) |> Base.encode16()
      first_name = Faker.Person.first_name()
      last_name = Faker.Person.last_name()
      email = "#{String.downcase(first_name)}_#{String.downcase(last_name)}@example.com"
      balance = 0
      MyBroadwayApp.UserStorage.add_user(id, email, balance)
    end)
  end

  defp publish_events(users) do
    Enum.each(1..100, fn _ ->
      random_user = Enum.random(users)
      event = random_event(random_user.id)
      Logger.info("User #{random_user.id} generated event: #{inspect(event)}")
      MyBroadwayApp.EventHandler.handle_event(event)
    end)

    Logger.info("100 random events have been processed for 50 random users.")

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
