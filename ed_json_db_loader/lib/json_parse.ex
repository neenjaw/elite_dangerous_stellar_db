defmodule ED.JsonParse do
  def parse_line(line \\ "", %{buffer: buffer, bracket_count: bracket_count}, repo) do
    line
    |> String.split("", trim: true)
    |> handle_line(buffer, bracket_count, repo)
  end

  defp handle_line([], buffer, bracket_count, _repo) do
    %{buffer: buffer, bracket_count: bracket_count}
  end

  defp handle_line([c | t], buffer, bracket_count, repo) do
    case c do
      "{" ->
        handle_line(t, [buffer, c], bracket_count + 1, repo)

      "}" ->
        case bracket_count - 1 do
          0 ->
            entry = IO.iodata_to_binary([buffer, c])
            Task.async(fn -> process(entry, repo) end)
            handle_line(t, [], 0, repo)

          n ->
            handle_line(t, [buffer, c], n, repo)
        end

      _ ->
        case bracket_count do
          0 ->
            handle_line(t, [buffer], bracket_count, repo)

          _ ->
            handle_line(t, [buffer, c], bracket_count, repo)
        end
    end
  end

  defp process(entry, repo) do
    entry = Jason.decode!(entry)

    star_system = ED.StarSystem.create_from_entry(entry)

    ED.Query.insert_system(repo, star_system)

    stars =
      entry["bodies"]
      |> Enum.filter(fn body -> body["type"] == "Star" end)
      |> Enum.map(fn body ->
        ED.Star.create_from_body_entry(star_system.id, body)
      end)

    ED.Query.insert_stars(repo, stars)
  end
end
