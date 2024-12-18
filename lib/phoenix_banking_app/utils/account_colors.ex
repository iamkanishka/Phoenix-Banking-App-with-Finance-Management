defmodule PhoenixBankingApp.Constants.AccountColors do
  def get_account_type_colors(:depository) do
    %{
      bg: "bg-blue-25",
      light_bg: "bg-blue-100",
      title: "text-blue-900",
      sub_text: "text-blue-700"
    }
  end

  def get_account_type_colors(:credit) do
    %{
      bg: "bg-success-25",
      light_bg: "bg-success-100",
      title: "text-success-900",
      sub_text: "text-success-700"
    }
  end

  def get_account_type_colors(_type) do
    %{
      bg: "bg-green-25",
      light_bg: "bg-green-100",
      title: "text-green-900",
      sub_text: "text-green-700"
    }
  end
end
