defmodule PhoenixBankingAppWeb.Auth.Components.AuthFormLive do
  alias Appwrite.Services.Database
  alias PhoenixBankingApp.Dwolla.Customer
  alias PhoenixBankingAppWeb.Auth.Validators.FormValidator
  alias Appwrite.Services.Accounts
  alias Appwrite.Utils

  use PhoenixBankingAppWeb, :live_component

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
            {"" <>
              if @user,
                do: "Link Account",
                else: if(@type == "sign-in", do: "Sign In", else: "Sign Up")}
            <p class="text-16 font-normal text-gray-600">
              {"" <>
                if @user, do: "Link your account to get started", else: "Please enter your details"}
            </p>
          </h1>
        </div>
      </header>



      <div class="flex flex-col gap-4">
          <.live_component
            module={PhoenixBankingAppWeb.CustomComponents.PlaidLinkLive}
            id={:plaidlink}
            user={@user}
           variant="primary"
          />
        </div>

      <%= if @user != nil do %>
        <%!-- <div class="flex flex-col gap-4">
          <.live_component
            module={PhoenixBankingAppWeb.CustomComponents.PlaidLinkLive}
            id={:plaidlink}
            user={:user}
            ready={true}
            variant="primary"
          />
        </div> --%>
      <% else %>
        <%!-- <.simple_form for={@form} phx-change="validate" phx-submit="save"> --%>
        <.simple_form for={@form} phx-submit="save" phx-change="validate" phx-target={@myself}>
          <%= for  %{field: field, label: label, type: type, placeholder: placeholder }  <- @form_fields do %>
            <%= if (@type == "sign-in" and field in [:email, :password]) or  @type == "sign-up" do %>
              <.input type={type} field={@form[field]} label={label} placeholder={placeholder} />
              <%= if @form_errors[field] do %>
                <span class="error-message">{@form_errors[field]}</span>
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

          <.link
            patch={~p"/#{if @type == "sign-in", do: "auth/sign-up", else: "auth/sign-in"}"}
            class="form-link"
          >
            <p>{if(@type == "sign-in", do: "Sign Up", else: "Sign In")}</p>
          </.link>
        </footer>
      <% end %>
    </section>
    """
  end

  @impl true
  def update(assigns, socket) do
    form_fields = [
      %{field: :first_name, label: "First Name", type: "text", placeholder: "First Name"},
      %{field: :last_name, label: "Last Name", type: "text", placeholder: "Last Name"},
      %{field: :address1, label: "Address", type: "text", placeholder: "123, Main St"},
      %{field: :city, label: "City", type: "text", placeholder: "Your City"},
      %{field: :state, label: "State", type: "text", placeholder: "NY"},
      %{field: :postal_code, label: "Postal Code", type: "text", placeholder: "12345"},
      %{field: :date_of_birth, label: "Date Of Birth", type: "text", placeholder: "YYYY-MM-DD"},
      %{field: :ssn, label: "SSN", type: "text", placeholder: "123-45-6789"},
      %{field: :email, label: "Email", type: "text", placeholder: "your_email@example.com"},
      %{field: :password, label: "Password", type: "text", placeholder: "Your Password"}
    ]

    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)

    {:ok,
     socket
     #  |> assign(:form, to_form(%{}))
     |> assign(:form, form)
     |> assign(:form_fields, form_fields)
     |> assign(:is_loading, false)
     |> assign(:form_errors, %{})
     |> assign(:user, nil)
     |> assign(assigns)}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    # Define validation rules
    IO.inspect(params, label: "Params")

    rules =
      if @type == "sign-up" do
        [
          {:first_name, :string, &(&1 != ""), "First Nam is required"},
          {:last_name, :string, &(&1 != ""), "Last Nam is required"},
          {:address1, :string, &(&1 != ""), "Address is required"},
          {:city, :string, &(&1 != ""), "City is required"},
          {:state, :string, &(&1 != ""), "State is required"},
          {:postal_code, :integer, &(&1 != ""), "Postal Code is required"},
          {:date_of_birth, :string, &(&1 != ""), "Date of birth is required"},
          {:ssn, :string, &(&1 != ""), "SSN is required"},
          {:email, :string, &String.contains?(&1 || "", "@"), "Email must be valid"},
          {:password, :string, &(&1 != ""), "Password is required"}

          # {:email, :string, &String.contains?(&1 || "", "@"), "Email must be valid"},
          # {:age, :integer, &(is_nil(&1) or String.to_integer(&1) > 0),
          #  "Age must be a positive number"}
        ]
      else
        [
          {:email, :string, &String.contains?(&1 || "", "@"), "Email must be valid"},
          {:password, :string, &(&1 != ""), "Password is required"}
        ]
      end

    errors = FormValidator.validate_form(params, rules)

    # {:noreply, assign(socket,form_errors: errors)}
    {:noreply, socket}
  end

  # filter_params: %{"gender" => "", "id" => "", "name" => "Emily", "weight" => ""}
  # [debug] HANDLE EVENT "search" in PhxSimpleTableWeb.TableLive.Show
  #   Component: PhxSimpleTableWeb.TableLive.Components.Filter
  #   Parameters: %{"table_schema" => %{"gender" => "", "id" => "", "name" => "Emily", "weight" => ""}}

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    IO.inspect(params, label: "Params")
    # Define validation rules
    rules = [
      {:name, :string, &(&1 != ""), "Name is required"},
      {:email, :string, &String.contains?(&1 || "", "@"), "Email must be valid"},
      {:age, :integer, &(is_nil(&1) or String.to_integer(&1) > 0),
       "Age must be a positive number"}
    ]

    errors = FormValidator.validate_form(params, rules)

    if errors == %{} do
      # Proceed with form processing
      {
        :noreply,
        socket |> put_flash(:info, "Form submitted successfully!")
        #  |> push_patch(to: "/")
      }
    else
      {:noreply, assign(socket, form_errors: errors)}
    end

    if(socket.assigns.type == "sign-in") do
      sign_in(params["email"], params["password"], socket)
    else
      params = Map.merge(params, %{"type" => "personal"})

      sign_up(params, socket)
    end

    {:noreply, socket}
  end

  defp sign_in(email, password, socket) do
    try do
      assign_loader(socket, true)

      user_data =
        Accounts.create_email_password_session(email, password)

      Utils.Client.set_session(user_data.secret)

      {:noreply,
       socket
       |> assign_loader(false)
       #  |> assign_user(user_data)
       |> push_patch(to: ~p"/")}
    catch
      {:error, error} ->
        {:error, error}
    end
  end

  defp sign_up(user_data, socket) do
    assign_loader(socket, true)
    full_name = "#{user_data["first_name"]} #{user_data["last_name"]}"
    new_user = Accounts.create(nil, user_data["email"], user_data["password"], full_name)

    token = "ritHSyiR6KZXcOOmkGGOTdOiI9c9oUygQbJbeEMGAPzLUlhBZB"
    atomized_user_data = Map.new(user_data, fn {key, value} -> {String.to_atom(key), value} end)

    # Update the User state
    updated_user_state_data = update_user_state_field(atomized_user_data)

    dwolla_id = Customer.create_verified(token, updated_user_state_data)

    user_session =
      Accounts.create_email_password_session(user_data["email"], user_data["password"])

    Utils.Client.set_session(user_session.secret)

    updated_user_data =
      Map.merge(user_data, %{"dwolla_id" => dwolla_id, "user_id" => new_user["$id"]})

    user_doc =
      Database.create_document(
        get_appwrite_database_id(),
        get_user_collection_id(),
        nil,
        updated_user_data
      )

    {:noreply,
     socket
     |> assign_loader(false)
     |> assign_user(user_doc)}
  end

  defp update_user_state_field(user_data) do
    Map.update!(user_data, :state, fn state ->
      state
      # Take the first 2 characters
      |> String.slice(0, 2)
      # Convert them to uppercase
      |> String.upcase()
    end)
  end

  defp get_appwrite_database_id() do
    case Application.get_env(get_app_name(), :appwrite_database_id) do
      nil ->
        nil

      database_id ->
        database_id
    end
  end

  defp get_user_collection_id() do
    case Application.get_env(get_app_name(), :appwrite_user_collection_id) do
      nil ->
        nil

      user_collection_id ->
        user_collection_id
    end
  end

  def get_app_name do
    Mix.Project.config()[:app]
  end

  defp assign_loader(socket, loader_status) do
    assign(socket, :is_loading, loader_status)
  end

  defp assign_user(socket, user) do
    assign(socket, :user, user)
  end
end
