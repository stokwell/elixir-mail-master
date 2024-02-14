defmodule MyBroadwayApp.EventHandler do
  import MyBroadwayApp.Events

  def handle_event(%MyBroadwayApp.Events.FinishingMeditation{} = event) do
    handle_finishing_event(event, 10)
  end

  def handle_event(% MyBroadwayApp.Events.FinishingIntro{} = event) do
    handle_finishing_event(event, 20)
  end

  def handle_event(% MyBroadwayApp.Events.FinishingCourse{} = event) do
    handle_finishing_event(event, 30)
  end

  def handle_event(_event) do
    IO.puts("Unknown event type")
  end

  defp handle_finishing_event(event, balance_change) do
    # Process.sleep(20_000)

    IO.puts("Handling #{event.__struct__.__name__} event for user #{event.user_id}")

    with {:ok, user} <- MyBroadwayApp.UserStorage.get_user(event.user_id),
         {:ok, updated_user} <- MyBroadwayApp.UserStorage.update_user(event.user_id, user.email, user.balance + balance_change) do
      IO.puts("User's #{event.user_id} account updated successfully. New balance: #{updated_user.balance}")

      if updated_user.balance >= 100 do
        send_email(updated_user.email)
        # After sending email, decrement the balance by 100
        {:ok, updated_user_after_email} = MyBroadwayApp.UserStorage.update_user(event.user_id, updated_user.email, updated_user.balance - 100)
        IO.puts("User #{event.user_id} has been sent an email. Balance decremented by 100. Current balance: #{updated_user_after_email.balance}")
      else
        IO.puts("User #{event.user_id} hasn't reached the required amount of credits yet. Current balance: #{updated_user.balance} points")
      end
    else
      _ ->
        IO.puts("Failed to retrieve or update user account.")
    end
  end

  defp send_email(user_email) do
    IO.puts("Hello #{user_email}! Please check out our special gifts for you!")
  end
end
