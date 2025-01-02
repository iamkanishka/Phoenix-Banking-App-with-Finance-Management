defmodule PhoenixBankingAppWeb.Auth.Validators.FormValidator do
  @moduledoc """
  Utility module for validating form inputs with customizable rules.
  """

  @type validation_rule() :: {atom(), any(), (any() -> boolean()), String.t()}

  @doc """
  Validates a form input based on a list of rules.

  ## Parameters
    - `field`: The field name (as an atom).
    - `value`: The value to validate.
    - `rules`: A list of validation rules, each specified as:
      `{field_name, expected_value_or_type, validation_fn, error_message}`.

  ## Returns
    - An error message string if validation fails, otherwise `nil`.

  ## Example
      iex> validate(:name, "John", [
      ...>   {:name, :string, &(&1 != ""), "Name cannot be blank"}
      ...> ])
      nil

      iex> validate(:name, "", [
      ...>   {:name, :string, &(&1 != ""), "Name cannot be blank"}
      ...> ])
      "Name cannot be blank"
  """
  def validate(field, value, rules) do
    rules
    |> Enum.find_value(fn {rule_field, _expected, validator, error_message} ->
      if rule_field == field and not validator.(value), do: error_message
    end)
  end

  @doc """
  Validates multiple fields in a form using specified rules.

  ## Parameters
    - `form_data`: The map of form inputs.
    - `rules`: A list of validation rules for all fields.

  ## Returns
    - A map of field errors. If no errors, returns an empty map.

  ## Example
      iex> validate_form(%{"name" => "", "age" => "20"}, [
      ...>   {:name, :string, &(&1 != ""), "Name is required"},
      ...>   {:age, :integer, &String.to_integer(&1) > 0, "Age must be a positive number"}
      ...> ])
      %{"name" => "Name is required"}
  """
  def validate_form(form_data, type) do
    get_form_rules(type)
    |> Enum.reduce(%{}, fn {field, _expected, _validator, _error_msg} = rule, errors ->
      value = Map.get(form_data, Atom.to_string(field)) || nil
      case validate(field, value, [rule]) do
        nil -> errors
        error_msg -> Map.put(errors, Atom.to_string(field), error_msg)
      end
    end)
  end


  defp get_form_rules(type) do
    if type == "sign-up" do
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

      ]
    else
      [
        {:email, :string, &String.contains?(&1 || "", "@"), "Email must be valid"},
        {:password, :string, &(&1 != ""), "Password is required"}
      ]
    end
  end

end
