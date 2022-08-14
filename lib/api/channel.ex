defmodule Api.Channel do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @topic opts[:topic]
      alias Phoenix.PubSub
      require Logger

      def subscribe(topic \\ nil, room \\ nil) do
        topic =
          case topic do
            nil -> @topic
            _ -> topic
          end

        channel =
          case room do
            nil -> topic
            room -> topic <> ":" <> room
          end

        Logger.info("subscribing to #{channel}")

        PubSub.subscribe(Api.PubSub, channel, link: true)
      end

      def broadcast(params \\ {:error, "Data is empty"}) do
        params
        |> broadcast_subscribers([:data, :updated])
      end

      def broadcast(params \\ {:error, "Data is empty"}, topic, room) do
        params
        |> broadcast_subscribers([:data, :updated], topic, room)
      end

      defp broadcast_subscribers({:ok, result}, event) do
        PubSub.broadcast(Api.PubSub, @topic, {__MODULE__, event, result})
        {:ok, result}
      end

      defp broadcast_subscribers({:ok, result}, event, topic) do
        channel =
          case topic do
            nil -> @topic
            _ -> topic
          end

        Logger.info("broadcast sent to channel #{channel}")

        PubSub.broadcast(Api.PubSub, channel, {__MODULE__, event, result})
        {:ok, result}
      end

      defp broadcast_subscribers({:ok, result}, event, topic, room) do
        topic =
          case topic == nil do
            true -> @topic
            false -> topic
          end

        channel =
          case room == nil do
            false -> topic <> ":" <> room
            true -> topic
          end

        Logger.info("broadcast event sent to channel #{channel}")

        PubSub.broadcast(Api.PubSub, channel, {__MODULE__, event, result})
        {:ok, result}
      end

      defp broadcast_subscribers(_, {:error, reason}, _event), do: {:error, reason}
    end
  end
end
