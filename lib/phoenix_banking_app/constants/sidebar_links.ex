defmodule PhoenixBankingApp.Constants.SidebarLinks do

 @sidebar_links_consts [
    %{
      imgURL: "/icons/home.svg",
      route: "/",
      label: "Home",
    },
    %{
      imgURL: "/icons/dollar-circle.svg",
      route: "/my-banks",
      label: "My Banks",
    },
    %{
      imgURL: "/icons/transaction.svg",
      route: "/transaction-history",
      label: "Transaction History",
    },
    %{
      imgURL: "/icons/money-send.svg",
      route: "/payment-transfer",
      label: "Transfer Funds",
    },
  ]

  def get_sidebar_links, do: @sidebar_links_consts

end
