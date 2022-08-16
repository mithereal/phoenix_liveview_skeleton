defmodule ApiWeb.Schemas do
  alias OpenApiSpex.{Schema, Discriminator}

  defmodule System.Version.Response do
    @behaviour OpenApiSpex.Schema
    @derive [Jason.Encoder]
    @schema %Schema{
      title: "Platform Version",
      description: "The version of the platform",
      type: :object,
      properties: %{
        data: %Schema{type: :string, description: "The Platform Version"}
      },
      example: %{
        data: []
      },
      "x-struct": __MODULE__
    }
    def schema, do: @schema
    defstruct Map.keys(@schema.properties)
  end

  defmodule Users.List.Response do
    @behaviour OpenApiSpex.Schema
    @derive [Jason.Encoder]
    @schema %Schema{
      title: "Users List",
      description: "The List of Active Users",
      type: :object,
      properties: %{
        data: %Schema{type: :string, description: "The List Active Users"}
      },
      example: %{
        data: []
      },
      "x-struct": __MODULE__
    }

    def schema, do: @schema
    defstruct Map.keys(@schema.properties)
  end

  defmodule User.Show.Response do
    @behaviour OpenApiSpex.Schema
    @derive [Jason.Encoder]
    @schema %Schema{
      title: "User State",
      description: "The State of the User",
      type: :object,
      properties: %{
        data: %Schema{type: :string, description: "The User Data"}
      },
      example: %{
        data: %{}
      },
      "x-struct": __MODULE__
    }

    def schema, do: @schema
    defstruct Map.keys(@schema.properties)
  end
end
