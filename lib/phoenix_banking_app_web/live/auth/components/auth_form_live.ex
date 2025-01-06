defmodule PhoenixBankingAppWeb.Auth.Components.AuthFormLive do
  use PhoenixBankingAppWeb, :live_component
  alias PhoenixBankingApp.Services.AuthService

  alias PhoenixBankingAppWeb.Auth.Validators.FormValidator

  @impl true
  def render(assigns) do
    ~H"""
    <section class="auth-form">
      <header class="flex flex-col gap-5 md:gap-8">
        <.link navigate={~p"/"} class="cursor-pointer flex items-center gap-1">
          <img src="/images/app_logo.svg" width={34} height={34} alt="Horizon logo" />
          <h1 class="text-26 font-ibm-plex-serif font-bold text-black-1">Horizon</h1>
        </.link>

        <div class="flex flex-col gap-1 md:gap-3">
          <h1 class="text-24 lg:text-36 font-semibold text-gray-900">
            {"" <> if @type == "sign-in", do: "Sign In", else: "Sign Up"}
            <p class="text-16 font-normal text-gray-600">
              Please enter your details
            </p>
          </h1>
        </div>
      </header>

      <.simple_form for={@form} phx-submit="save" phx-change="validate" phx-target={@myself}>
        <%= for  %{field: field, label: label, type: type, placeholder: placeholder }  <- @form_fields do %>
          <%= if (@type == "sign-in" and field in [:email, :password]) or  @type == "sign-up" do %>
            <%!-- <div class="flex grid grid-cols-1 md:grid-cols-2 xl:grid-cols-2 gap-4"> --%>
            <.input type={type} field={@form[field]} label={label} placeholder={placeholder} />
            <%!-- </div> --%>
            <%= if @form_errors[field] do %>
              <span class=" text-sm text-red-600">{@form_errors[field]}</span>
            <% end %>
          <% end %>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">
            <%= if @is_loading do %>
              <div role="status">
                <svg
                  aria-hidden="true"
                  class="inline w-6 h-6 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600"
                  viewBox="0 0 100 101"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                    fill="currentColor"
                  />
                  <path
                    d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                    fill="currentFill"
                  />
                </svg>
                 <span class="sr-only">Loading...</span>
              </div>
            <% else %>
              {if @type == "sign-in", do: "Sign In", else: "Sign Up"}
            <% end %>
          </.button>
        </:actions>
      </.simple_form>

      <footer class="flex justify-center gap-1">
        <p class="text-14 font-normal text-gray-600">
          {if @type == "sign-in", do: "Don't have an account?", else: "Already have an account?"}
        </p>

        <.link phx-click="toggle-auth" phx-value-type={@type} phx-target={@myself} class="form-link">
          <p>{if(@type == "sign-in", do: "Sign Up", else: "Sign In")}</p>
        </.link>
      </footer>
    </section>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign_form()
     |> assign(:is_loading, false)
     |> assign(:user, nil)
     |> assign(assigns)}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    # Define validation rules
     IO.inspect(params, label: "Params")

    errors = FormValidator.validate_form(params, socket.assigns.type)
    IO.inspect(errors, label: "Errors")

    atomized_form_errors = Map.new(errors, fn {key, value} -> {String.to_atom(key), value} end)
    # {:noreply, assign(socket,form_errors: errors)}
    {:noreply,
    socket
    # |> assign(socket.assigns)
    #  |> assign(:form_errors, atomized_form_errors)
  }
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    IO.inspect(params, label: "Params")
    # # Define validation rules
    errors = FormValidator.validate_form(params, socket.assigns.type)

    # if errors == %{} do
    #   # Proceed with form processing
    #   {
    #     :noreply,
    #     socket |> put_flash(:info, "Form submitted successfully!")
    #     #  |> push_patch(to: "/")
    #   }
    # else
    #   {:noreply, assign(socket, form_errors: errors)}
    # end

    assign_loader(socket, true)

    if socket.assigns.type == "sign-in" do
      case AuthService.sign_in(params["email"], params["password"]) do
        {:ok, need_bank_connectivity, user_id} ->
          assign_loader(socket, false)

          if need_bank_connectivity do
            {:noreply,
             socket
             |> assign_loader(false)
             |> put_flash(:info, "Logged in successfully")
             |> put_flash(:info, "Link your account to get started")}
          else
            assign_loader(socket, false)

            {:noreply,
             socket
             |> assign_loader(false)
             |> put_flash(:info, "Logged in successfully")
             |> push_navigate(to: "/#{user_id}", replace: true)}
          end

        {:error, error} ->
          {:noreply, assign(socket, form_errors: error)}
          {:error, error}
      end
    else
      params = Map.merge(params, %{"type" => "personal"})

      case AuthService.sign_up(params) do
        {:ok, _user} ->
          {:noreply,
           socket
           |> put_flash(:info, "Signed up successfully")
           |> put_flash(:info, "Link your account to get started")
           |> assign_loader(false)}

        {:error, error} ->
          {:noreply, assign(socket, form_errors: error)}
          {:error, error}
      end
    end
  end

  @impl true
  def handle_event("toggle-auth", %{"type" => current_type}, socket) do
    new_type = if current_type == "sign-in", do: "sign-up", else: "sign-in"

    # Optionally use push_patch to update the URL
    {:noreply,
     socket
     |> push_navigate(to: "/auth/#{new_type}", replace: true)}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)

    assign(socket, %{form: form, form_fields: AuthService.get_form_fields(), form_errors: %{}})
  end

  defp assign_loader(socket, loader_status) do
    # assign loader with status
    assign(socket, :is_loading, loader_status)
  end
end
