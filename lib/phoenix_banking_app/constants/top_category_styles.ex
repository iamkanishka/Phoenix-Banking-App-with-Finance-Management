defmodule PhoenixBankingApp.Constants.TopCategoryStyles do
  @top_category_styles %{
    "Food and Drink" => %{
      bg: "bg-blue-25",
      circle_bg: "bg-blue-100",
      text: %{
        main: "text-blue-900",
        count: "text-blue-700"
      },
      progress: %{
        bg: "bg-blue-100",
        indicator: "bg-blue-700"
      },
      icon: "/images/monitor.svg"
    },
    "Travel" => %{
      bg: "bg-success-25",
      circle_bg: "bg-success-100",
      text: %{
        main: "text-success-900",
        count: "text-success-700"
      },
      progress: %{
        bg: "bg-success-100",
        indicator: "bg-success-700"
      },
      icon: "/images/coins.svg"
    },
    :default => %{
      bg: "bg-pink-25",
      circle_bg: "bg-pink-100",
      text: %{
        main: "text-pink-900",
        count: "text-pink-700"
      },
      progress: %{
        bg: "bg-pink-100",
        indicator: "bg-pink-700"
      },
      icon: "/images/shopping-bag.svg"
    }
  }
  def styles, do: @top_category_styles

  def get_top_category_styles(category) do
    Map.get(@top_category_styles, category, @top_category_styles[:default])
  end
end
