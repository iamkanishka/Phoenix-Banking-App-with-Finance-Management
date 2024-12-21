defmodule PhoenixBankingAppWeb.HomeLive.Components.Category do
  alias PhoenixBankingApp.Constants.TopCategoryStyles
  use PhoenixBankingAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class={"gap-[18px] flex p-4 rounded-xl #{assigns.bg}"}>
      <figure class={"flex-center size-10 rounded-full #{assigns.circle_bg}"}>
        <img src={@icon} width="20" height="20" alt={@category.name} />
      </figure>

      <div class="flex w-full flex-1 flex-col gap-2">
        <div class="text-14 flex justify-between">
          <h2 class={"font-medium #{assigns.text_main}"}>{@category.name}</h2>

          <h3 class={"font-normal #{assigns.text_count}"}>{@category.count}</h3>
        </div>

        <div>
          <.live_component
            module={PhoenixBankingAppWeb.HomeLive.Components.Progress}
            id={:progress_bar}
            value={@category.count / @category.total_count * 100}
            class={"h-2 w-full #{assigns.progress_bg}"}
            indicator_class={"h-2 w-full #{assigns.progress_indicator}"}
          />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    style = TopCategoryStyles.get_top_category_styles(socket.category.name)

    {:ok,
     socket
     |> assign(style)
     |> assign(assigns)}
  end

  # def mount_category_styles(category) do
  #   style_for_category(category.name)
  #   |> Map.merge(%{category: category})
  # end
end
