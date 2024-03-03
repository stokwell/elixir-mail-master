defmodule MailMaster.User do
  use Ecto.Schema

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :email, :string
    field :balance, :integer

    timestamps()
  end
end
