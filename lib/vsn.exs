defmodule Vsn do
  @default_version "1.0.0-default"
  @default_codename "default"

  def version do
    # Build the version number from Git.
    # It will be something like 1.0.0-beta1 when built against a tag, and
    # 1.0.0-beta1+18.ga9f2f1ee when built against something after a tag.
    with {:ok, string} <- get_version(),
         [_, version, commit] <-
           Regex.run(~r/(v[\d\.]+(?:\-[a-zA-Z]+\d*)?)(.*)/, String.trim(string)) do
      String.replace(version, ~r/^v/, "") <>
        (commit |> String.replace(~r/^-/, "+") |> String.replace("-", "."))
    else
      _ ->
        @default_version
    end
  end

  def codename(version, delimiter \\ "-") do
    result = String.split(version, delimiter)

    case Enum.count(result) do
      1 ->
        @default_codename

      _ ->
        {_, r} = Enum.fetch(result, 1)
        split = String.split(r, ".")
        List.first(split)
    end
  end

  def get_version do
    {status, result} =
      case File.read("VERSION") do
        {:error, _} ->
          case System.cmd("git", ["describe"]) do
            {string, 0} ->
              case string do
                "fatal: No names found, cannot describe anything." ->
                  {:error, "Could not get version. error: No Tags Found"}

                _ ->
                  {:ok, string}
              end

            {error, errno} ->
              {:error,
               "Could not get version. errno: #{inspect(errno)}, error: #{inspect(error)}"}
          end

        ok ->
          ok
      end

    case status do
      :ok -> result
      :error -> @default_version
      _ -> @default_version
    end
  end

  def get_codename do
    case File.read("CODENAME") do
      {:error, _} ->
        version = get_version()

        codename(version)

      {:ok, data} ->
        data
    end
  end

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @default_version opts[:version]
      @default_codename opts[:codename]

      def version(default_version \\ nil) do
        # Build the version number from Git.
        # It will be something like 1.0.0-beta1 when built against a tag, and
        # 1.0.0-beta1+18.ga9f2f1ee when built against something after a tag.

        default_version =
          case default_version do
            nil -> @default_version
            _ -> default_version
          end

        with {:ok, string} <- get_version(),
             [_, version, commit] <-
               Regex.run(~r/(v[\d\.]+(?:\-[a-zA-Z]+\d*)?)(.*)/, String.trim(string)) do
          String.replace(version, ~r/^v/, "") <>
            (commit |> String.replace(~r/^-/, "+") |> String.replace("-", "."))
        else
          _ ->
            default_version
        end
      end

      def codename(version, delimiter \\ "-") do
        result = String.split(version, delimiter)

        case Enum.count(result) do
          1 ->
            @default_codename

          _ ->
            {_, r} = Enum.fetch(result, 1)
            split = String.split(r, ".")
            List.first(split)
        end
      end

      def get_version do
        {status, result} =
          case File.read("VERSION") do
            {:error, _} ->
              case System.cmd("git", ["describe"]) do
                {string, 0} ->
                  case string do
                    "fatal: No names found, cannot describe anything." ->
                      {:error, "Could not get version. error: No Tags Found"}

                    _ ->
                      {:ok, string}
                  end

                {error, errno} ->
                  {:error,
                   "Could not get version. errno: #{inspect(errno)}, error: #{inspect(error)}"}
              end

            ok ->
              ok
          end

        case status do
          :ok -> result
          :error -> @default_version
          _ -> @default_version
        end
      end

      def get_codename do
        case File.read("CODENAME") do
          {:error, _} ->
            version = get_version()

            codename(version)

          {:ok, data} ->
            data
        end
      end
    end
  end
end
