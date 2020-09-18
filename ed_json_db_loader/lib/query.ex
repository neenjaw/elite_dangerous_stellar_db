defmodule ED.Query do
  @system_table "stellar_map.system"
  @star_table "stellar_map.star"

  @system_insert """
  INSERT INTO #{@system_table} (id, position) VALUES ($1, $2)
  """

  @star_insert """
  INSERT INTO #{@star_table} (id, system_id, system_order, name, type, subtype, scoopable, distance_to_arrival)
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
  """

  def insert_system(repo, %ED.StarSystem{} = s) do
    Postgrex.query!(repo, @system_insert, [s.id, s.position])
  end

  def insert_stars(repo, l) when is_list(l) do
    Enum.each(l, &insert_star(repo, &1))
  end

  def insert_star(repo, %ED.Star{} = s) do
    Postgrex.query!(repo, @star_insert, [
      s.id,
      s.system_id,
      s.system_order,
      s.name,
      s.type,
      s.subtype,
      s.scoopable,
      s.distance_to_arrival
    ])
  end
end
