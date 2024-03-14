defmodule MailMaster.MyMailer do
  use Bamboo.Mailer, otp_app: :mail_master

  import Bamboo.Email

  alias MailMaster.Repo
  alias MailMaster.User

  def send_email(user_id, new_balance) do
    case fetch_user(user_id) do
      {:ok, user} ->
        new_email(
          to: user.email,
          from: "support@myapp.com",
          subject: "Welcome to the app.",
          html_body: "<strong>#{user.balance}</strong>",
          text_body: "Thanks for joining!"
        )
        |> deliver_now!

      {:error, reason} ->
        Logger.error("Failed to fetch user email: #{reason}")
    end
  end

  defp fetch_user(user_id) do
    case Repo.get(User, user_id) do
      %User{} = user -> {:ok, user}
      nil -> {:error, "User not found"}
    end
  end
end
