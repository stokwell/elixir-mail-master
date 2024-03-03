defmodule MailMaster.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string, null: false, unique: true
      add :email, :string, null: false, unique: true
      add :balance, :integer, default: 0

      timestamps()
    end
  end
end
