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
    case MyBroadwayApp.UserStorage.get_user(event.user_id) do
      {:ok, user} ->
        handle_user(user, balance_change)

      {:error, _reason} ->
        IO.puts("Failed to retrieve user account.")
    end
  end

  defp handle_user(user, balance_change) do
    case update_user_balance(user, balance_change) do
      {:ok, updated_user} ->
        if updated_user.balance >= 100 do
          IO.puts("User #{updated_user.id} with balance: #{updated_user.balance} reached the required amount of 100 credits")
          send_email(updated_user)
        else
          IO.puts("User #{user.id} hasn't reached the required amount of credits yet. Current balance: #{updated_user.balance} points")
        end

      {:error, reason} ->
        IO.puts("Failed to update user balance: #{reason}")
    end
  end

  defp update_user_balance(user, balance_change) do
    IO.puts("User #{user.id} gets #{balance_change} on its account")
    new_balance = user.balance + balance_change

    MyBroadwayApp.UserStorage.update_user(user.id, user.email, new_balance)
  end

  defp send_email(user) do
    IO.puts("Hello #{user.email}! Please check out our special gifts for you! Your credits: #{user.balance}")
  end
end
