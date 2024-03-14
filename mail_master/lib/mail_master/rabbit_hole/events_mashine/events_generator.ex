defmodule MailMaster.RabbitHole.EventsMashine.EventsGenerator do
  alias MailMaster.Repo
  alias MailMaster.User

  def generate_events(number_of_events) when is_integer(number_of_events) and number_of_events > 0 do
    users = Repo.all(User)

    Enum.map(1..number_of_events, fn _ ->
      random_user = Enum.random(users)
      random_event = Enum.random(["finishing_intro", "finishing_meditation", "finishing_course"])

      %{"user_id" => random_user.id, "event_type" => random_event, "timestamp" => :os.system_time(:millisecond)}
    end)
  end
end
