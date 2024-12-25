defmodule PhoenixBankingApp.Dwolla.Errors do
  @moduledoc """
  Dwolla Error response data structure.
  """

  defstruct code: nil, message: nil, errors: []
  @type t :: %__MODULE__{code: String.t,
                         message: String.t,
                         errors: [PhoenixBankingApp.Dwolla.Errors.Error.t]
                        }

  defmodule Error do
    @moduledoc """
    Dwolla Error data structure.
    """

    defstruct code: nil, message: nil, path: nil
    @type t :: %__MODULE__{code: String.t, message: String.t, path: String.t}
  end
end
