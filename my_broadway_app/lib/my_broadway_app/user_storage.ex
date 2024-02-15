defmodule MyBroadwayApp.UserStorage do
  use GenServer

  @table_name :users

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    IO.puts("Starting UserStorage GenServer...")

    IO.inspect(@table_name)

    case :ets.info(@table_name) do
      {:ok, _} ->
        :ok
      :undefined ->
        :ets.new(@table_name, [:set, :public, :named_table])
    end

    {:ok, @table_name}
  end

  # Client functions
  def add_user(id, email, balance) do
    GenServer.call(__MODULE__, {:add_user, id, email, balance})
  end

  def get_all_users() do
    GenServer.call(__MODULE__, :get_all_users)
  end

  def get_user(id) do
    GenServer.call(__MODULE__, {:get_user, id})
  end

  def update_user(id, email, balance) do
    GenServer.call(__MODULE__, {:update_user, id, email, balance})
  end

  def delete_user(id) do
    GenServer.call(__MODULE__, {:delete_user, id})
  end

  # Server callbacks
  def handle_call({:add_user, id, email, balance}, _from, table_name) do
    :ets.insert(table_name, {id, %{email: email, balance: balance}})
    {:reply, :ok, table_name}
  end

  def handle_call(:get_all_users, _from, table_name) do
    users = :ets.tab2list(table_name)
    users = Enum.map(users, fn {id, user} ->
      %{id: id, email: Map.get(user, :email), balance: Map.get(user, :balance)}
    end)
    {:reply, users, table_name}
  end

  def handle_call({:get_user, id}, _from, table_name) do
    case :ets.lookup(table_name, id) do
      [{^id, user}] -> {:reply, {:ok, Map.put_new(user, :id, id)}, table_name}
      _ -> {:reply, :error, table_name}
    end
  end

  def handle_call({:update_user, id, email, balance}, _from, table_name) do
    case :ets.lookup(table_name, id) do
      [{^id, user}] ->
        updated_user = %{user | email: email, balance: balance}
        :ets.insert(table_name, {id, updated_user})
        {:reply, {:ok, Map.put_new(updated_user, :id, id)}, table_name}
      _ -> {:reply, :error, table_name}
    end
  end

  def handle_call({:delete_user, id}, _from, table_name) do
    :ets.delete(table_name, id)
    {:reply, :ok, table_name}
  end
end
