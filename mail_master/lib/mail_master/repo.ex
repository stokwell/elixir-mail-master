defmodule MailMaster.Repo do
  use Ecto.Repo,
    otp_app: :mail_master,
    adapter: Ecto.Adapters.Postgres
end
