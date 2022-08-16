defmodule ApiWeb.ApiSpec do
  alias OpenApiSpex.{OpenApi, Server, Info, Paths}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(ApiWeb.Endpoint, otp_app: :api)
      ],
      info: %Info{
        title: Application.get_env(:api, ApiWeb.Endpoint)[:url][:host] <> " Developer API",
        version: Api.Application.version()
      },
      # populate the paths from a phoenix router
      paths: Paths.from_router(ApiWeb.Router)
    }
    # discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end
end
