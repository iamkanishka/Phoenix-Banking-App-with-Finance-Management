defmodule PhoenixBankingApp.Constants.TransactionCategoryStyles do
  @styles %{
    "Food and Drink" => %{
      border_color: "border-rose-400",
      background_color: "bg-pink-500",
      text_color: "text-pink-700",
      chip_background_color: "bg-inherit"
    },
    "Payment" => %{
      border_color: "border-blue-600",
      background_color: "bg-green-600",
      text_color: "text-success-700",
      chip_background_color: "bg-inherit"
    },
    "Bank Fees" => %{
      border_color: "border-success-600",
      background_color: "bg-green-600",
      text_color: "text-success-700",
      chip_background_color: "bg-inherit"
    },
    "Transfer" => %{
      border_color: "border-red-700",
      background_color: "bg-red-700",
      text_color: "text-red-700",
      chip_background_color: "bg-inherit"
    },
    "Processing" => %{
      border_color: "border-[#F2F4F7]",
      background_color: "bg-gray-500",
      text_color: "text-[#344054]",
      chip_background_color: "bg-[#F2F4F7]"
    },
    "Success" => %{
      border_color: "border-[#12B76A]",
      background_color: "bg-[#12B76A]",
      text_color: "text-success-700",
      chip_background_color: "bg-[#ECFDF3]"
    },
    "Travel" => %{
      border_color: "border-[#0047AB]",
      background_color: "bg-blue-500",
      text_color: "text-blue-700",
      chip_background_color: "bg-[#ECFDF3]"
    },
    :default => %{
      border_color: "",
      background_color: "bg-blue-500",
      text_color: "text-blue-700",
      chip_background_color: "bg-inherit"
    }
  }

  def styles, do: @styles

  def get_styles(category) do
    Map.get(@styles, category, @styles[:default])
  end
end
