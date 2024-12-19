defmodule PhoenixBankingAppWeb.CustomComponents.CategoryBadge do
  alias PhoenixBankingApp.Constants.TransactionCategoryStyles
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class={[
      "category-badge",
      get_style(@chip_style, :border_color),
      get_style(@chip_style, :chip_background_color)
    ]}>
      <div class={["size-2 rounded-full", get_style(@chip_style, :background_color)]}></div>

      <p class={["text-[12px] font-medium", get_style(@chip_style, :text_color)]}>{@category}</p>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    style = TransactionCategoryStyles.get_styles(assigns.category)

    {:ok,
     socket
     |> assign(:chip_style, style)
     |> assign(assigns)}
  end

  def get_style(style, key) do
    Map.get(style, key)
  end
end
