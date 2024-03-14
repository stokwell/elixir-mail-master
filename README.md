## Elixir learning project

To compile the app, please run the `mix compile` command in the `my_broadway_app` directory and start a mix session with `iex -S mix`. 

After that, you can start the app by running `MyBroadwayApp.Application.start(:normal, [])`. 

The app will generate an initial set of 50 users with 0 points in their accounts. Afterward, it will randomly generate events for each user and process these events asynchronously. You can view the result of every event handling in the terminal output.

## Next steps

Refactor the code line by line following Elixir best practices You may find valuable insights in this article on [Good and Bad Elixir](https://keathley.io/blog/good-and-bad-elixir.html) and this [course](https://www.youtube.com/watch?v=lZtdNCkevVw&list=PLWlFXymvoaJ_SWXOOm2JSqv86ZBkQ9-zo).

Currently, the application utilizes `:ets` for storing user information such as account balances. However, `:ets` is bound to the process and will be cleaned up after a process restart, potentially leading to the loss of application state. Consider using [:dets](https://www.erlang.org/doc/man/dets.html) as an alternative or integrating a proper relational database like Postgres with an Elixir adapter such as [Ecto](https://hexdocs.pm/ecto_sql/Ecto.Adapters.Postgres.html) for improved data persistence.

Lastly, explore deployment options for your Elixir application. Check out this [video](https://www.youtube.com/watch?v=i_k8VaiqjiM) by Tyler Pachal on deploying Elixir applications to container orchestrators using Docker for inspiration and guidance.


## Materials

Creating Note taking app using LiveView and GenServer - Part 1  https://abulasar.com/creating-note-taking-app-using-liveview-and-genserver-part-1

Implementing AMQP in an Elixir Application https://medium.com/caspertechteam/implementing-amqp-in-an-elixir-application-20734635436

https://medium.com/@r_trojanowski/working-with-a-huge-dataset-with-elixir-and-phoenix-94875e4169a5

https://github.com/aifrak/concurrent-data-processing-in-elixir/tree/main/tickets/lib

https://akoutmos.com/post/broadway-rabbitmq-and-the-rise-of-elixir/


https://medium.com/@pragprog/processing-ticketing-events-883fabf21605

