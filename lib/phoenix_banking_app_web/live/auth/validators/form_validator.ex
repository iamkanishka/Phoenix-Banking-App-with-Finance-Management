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
  def validate_form(form_data, rules) do
    rules
    |> Enum.reduce(%{}, fn {field, _expected, _validator, _error_msg} = rule, errors ->
      value = Map.get(form_data, Atom.to_string(field)) || nil
      case validate(field, value, [rule]) do
        nil -> errors
        error_msg -> Map.put(errors, Atom.to_string(field), error_msg)
      end
    end)
  end
end
