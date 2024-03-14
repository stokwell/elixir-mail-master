# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MailMaster.Repo.insert!(%MailMaster.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias MailMaster.Repo
alias MailMaster.User

import NaiveDateTime, only: [truncate: 2]

# Generate 10 users with fake names and emails
users = Enum.map(1..1000000, fn _ ->
  %{
    first_name: Faker.Person.first_name(),
    last_name: Faker.Person.last_name(),
    username: Faker.Internet.user_name(),
    email: Faker.Internet.email(),
    inserted_at: truncate(NaiveDateTime.utc_now(), :second),
    updated_at: truncate(NaiveDateTime.utc_now(), :second),
  }
end)

Repo.insert_all(User, users)
