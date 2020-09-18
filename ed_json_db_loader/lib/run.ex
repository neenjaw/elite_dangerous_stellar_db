defmodule Run do
  def load_to_db(file) do
    Postgrex.Types.define(MyApp.PostgresTypes, [Geo.PostGIS.Extension], [])

    opts = [
      database: "elite_dangerous",
      hostname: "localhost",
      username: "admin",
      password: "secret",
      types: MyApp.PostgresTypes,
      pool_size: 20
    ]

    {:ok, pid} = Postgrex.start_link(opts)

    file
    |> File.stream!()
    |> Enum.reduce(
      %{buffer: [], bracket_count: 0},
      &ED.JsonParse.parse_line(&1, &2, pid)
    )
    |> (fn acc -> ED.JsonParse.parse_line(acc, pid) end).()

    :ok
  end
end
