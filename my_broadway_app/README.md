## Elixir learning course

## Practice 

Refactor the code line by line following best practices, with particular attention to error handling and fault tolerance. You may find valuable insights in this article on [Good and Bad Elixir](https://keathley.io/blog/good-and-bad-elixir.html).

Additionally, consider exploring resources on OTP, GenServer, callbacks, Mix, and other Elixir concepts. This [video](https://www.youtube.com/watch?v=DCjRQUWK1HM) might provide helpful insights, especially if you're interested in practical examples like the game of stones.

Currently, the application utilizes `:ets` for storing user information such as account balances. However, `:ets` is bound to the process and will be cleaned up after a process restart, potentially leading to the loss of application state. Consider using [:dets](https://www.erlang.org/doc/man/dets.html) as an alternative or integrating a proper relational database like Postgres with an Elixir adapter such as [Ecto](https://hexdocs.pm/ecto_sql/Ecto.Adapters.Postgres.html) for improved data persistence.

Lastly, explore deployment options for your Elixir application. Check out this [video](https://www.youtube.com/watch?v=i_k8VaiqjiM) by Tyler Pachal on deploying Elixir applications to container orchestrators using Docker for inspiration and guidance.
