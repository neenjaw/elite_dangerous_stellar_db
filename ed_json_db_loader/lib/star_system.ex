defmodule ED.StarSystem do
  @enforce_keys [:id, :position]
  defstruct [:id, :position]

  def create_from_entry(entry) do
    x = entry["coords"]["x"]
    y = entry["coords"]["y"]
    z = entry["coords"]["z"]

    geo = %Geo.PointZ{coordinates: {x, y, z}, srid: 0}

    %__MODULE__{
      id: entry["id64"],
      position: geo
    }
  end
end
