defmodule ApiWeb.LiveHelpers do
  import Phoenix.LiveView
  alias Api.Accounts
  alias Api.Accounts.User
  alias ApiWeb.Router.Helpers, as: Routes
  alias ApiWeb.UserAuth
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `ApiWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, ApiWeb.XXX.FormComponent,
        id: @data.id || :new,
        action: @live_action,
        data: @data,
        return_to: Routes.property_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, ApiWeb.ModalComponent, modal_opts)
  end

  def assign_defaults(session, socket) do
    ApiWeb.Endpoint.subscribe(UserAuth.pubsub_topic())

    socket =
      assign_new(socket, :current_user, fn ->
        find_current_user(session)
      end)

    case socket.assigns.current_user do
      %User{} ->
        socket

      _other ->
        socket
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: Routes.user_session_path(socket, :new))
    end
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end
end
