defmodule PhoenixBankingAppWeb.Auth.Components.AuthForm do
  alias PhoenixBankingAppWeb.Auth.Validators.FormValidator
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <section class="auth-form">
      <header class="flex flex-col gap-5 md:gap-8">
        <.link navigate={~p"/"} class="cursor-pointer flex items-center gap-1">
          <img src="/images/logo.svg" width={34} height={34} alt="Horizon logo" />
          <h1 class="text-26 font-ibm-plex-serif font-bold text-black-1">Horizon</h1>
        </.link>

        <div class="flex flex-col gap-1 md:gap-3">
          <h1 class="text-24 lg:text-36 font-semibold text-gray-900">
            {"" <>
              if @user,
                do: "Link Account",
                else: if(@type == "sign-in", do: "Sign In", else: "Sign In")}
            <p class="text-16 font-normal text-gray-600">
              {"" <>
                if @user, do: "Link your account to get started", else: "Please enter your details"}
            </p>
          </h1>
        </div>
      </header>
      if @user != nil, do
      <div class="flex flex-col gap-4">
        <.live_component
          module={PhoenixBankingAppWeb.CustomComponents.PlaidLink}
          id="{:plaidlink}"
          user={%{}}
          variant="primary"
        />
      </div>
      else
      <.simple_form for={@form_data} phx-change="validate" phx-submit="save">
        <%= for  %{field: field, label: label, type: type}  <- @form_data do %>
          <%= if @type != "sign-in" or (field in [:email, :password]) do %>
            <.input type={type} field={field} label={label} value="" />
            <%= if @form_errors[field] do %>
              <span class="error-message">{@form_errors[field]}</span>
            <% end %>
          <% end %>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving..." type="submit">
            if @is_loading do
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
            else {if @type == "sign-in", do: "Sign In", else: "Sign Up"} end
          </.button>
        </:actions>
      </.simple_form>

      <footer class="flex justify-center gap-1">
        <p class="text-14 font-normal text-gray-600">
          if @type == "sign-in", do: "Don't have an account?" else: "Already have an account?"
        </p>

        <.link
          patch={~p"/#{if @type == "sign-in", do: "auth/sign-up", else: "auth/sign-in"}"}
          class="form-link"
        >
        </.link>
      </footer>
    </section>
    """
  end

  @impl true
  def update(_assigns, socket) do
    form_data = [
      %{field: "firstName", label: "First Name", type: "text"},
      %{field: "Last Name", label: "Last Name", type: "text"},
      %{field: "address1", label: "Address", type: "text"},
      %{field: "city", label: "City", type: "text"},
      %{field: "state", label: "State", type: "text"},
      %{field: "postalCode", label: "Postal Code", type: "text"},
      %{field: "dateOfBirth", label: "Date Of Birth", type: "text"},
      %{field: "ssn", label: "SSN", type: "text"},
      %{field: "email", label: "Email", type: "text"},
      %{field: "password", label: "Password", type: "password"}
    ]

    {:ok, assign(socket, form_data: form_data, form_errors: %{})}
  end

  @impl true
  def handle_event("validate", params, socket) do
    # Define validation rules

    rules =
      if @type == "sign-up" do
        [
          {:firstName, :string, &(&1 != ""), "First Nam is required"},
          {:lastName, :string, &(&1 != ""), "Last Nam is required"},
          {:address1, :string, &(&1 != ""), "Address is required"},
          {:city, :string, &(&1 != ""), "City is required"},
          {:state, :string, &(&1 != ""), "State is required"},
          {:postalCode, :integer, &(&1 != ""), "Postal Code is required"},
          {:dateOfBirth, :string, &(&1 != ""), "Date of birth is required"},
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

    {:noreply, assign(socket, form_data: params, form_errors: errors)}
  end

  @impl true
  def handle_event("save", params, socket) do
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
  end
end
