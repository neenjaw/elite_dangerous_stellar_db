defmodule ED.Star do
  @enforce_keys [
    :id,
    :system_id,
    :system_order,
    :name,
    :type,
    :subtype,
    :scoopable,
    :distance_to_arrival
  ]
  defstruct [
    :id,
    :system_id,
    :system_order,
    :name,
    :type,
    :subtype,
    :scoopable,
    :distance_to_arrival
  ]

  def create_from_body_entry(system_id, entry) do
    %__MODULE__{
      id: entry["id64"],
      system_id: system_id,
      system_order: entry["bodyId"],
      name: entry["name"],
      type: entry["type"],
      subtype: entry["subType"],
      scoopable: scoopable?(entry["spectralClass"]),
      distance_to_arrival: entry["distanceToArrival"]
    }
  end

  @scoopable_regex ~r/^(K|G|B|F|O|A|M)(?!(e|S))/

  @spec scoopable?(String.t() | nil) :: boolean()
  defp scoopable?(nil), do: false

  defp scoopable?(spectralClass) do
    String.match?(spectralClass, @scoopable_regex)
  end
end
