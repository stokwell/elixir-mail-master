defmodule MailMaster.RabbitHole.MyBroadway.Pipeline do
  use Broadway

  alias MailMaster.Repo
  alias MailMaster.User

  require Logger

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: MyBroadwayPipeline,
      producer: [
        module: {BroadwayRabbitMQ.Producer,
          queue: "events_queue",
          connection: [
            username: "guest",
            password: "guest",
            host: "rabbitmq"
          ]
        },
        concurrency: 20
      ],
      processors: [
        default: [
          concurrency: 20
        ]
      ]
    )
  end

  def handle_message(_, message, _) do
    case decode_json_message(message) do
      {:ok, data} ->
        user_id = data["user_id"]
        Logger.info("User with #{inspect(data["user_id"])} #{inspect(data["event_type"])}")

        amount =
          case data["event_type"] do
            "finishing_intro" -> 10
            "finishing_meditation" -> 20
            "finishing_course" -> 30
            _ -> 0
          end

        case update_user_balance(user_id, amount) do
          {:ok, new_balance} ->
            Logger.info("Updated user balance: #{new_balance}")
            {:ok, message}

            if new_balance > 100 do
              MailMaster.MyMailer.send_email(user_id, new_balance)
            end

          {:error, reason} ->
            Logger.error("Failed to update user balance: #{reason}")
            {:error, reason}
        end

      {:error, reason} ->
        Logger.error("Failed to decode message: #{reason}")
        {:error, reason}
    end

    message
  end

  defp update_user_balance(user_id, amount) do
    case Repo.get(User, user_id) do
      nil ->
        {:error, "User not found"}

      user ->
        new_balance = user.balance + amount
        user
        |> User.changeset(%{balance: new_balance})
        |> Repo.update()

        {:ok, new_balance}
    end
  end

  defp decode_json_message(message) do
    case Jason.decode(message.data) do
      {:ok, decoded_data} ->
        {:ok, decoded_data}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
