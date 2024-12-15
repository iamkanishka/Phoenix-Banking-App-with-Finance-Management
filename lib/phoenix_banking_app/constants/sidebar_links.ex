defmodule PhoenixBankingApp.Constants.SidebarLinks do

 @sidebar_links_consts [
    %{
      imgURL: "/images/home.svg",
      route: "/home",
      label: "Home",
    },
    %{
      imgURL: "/images/dollar-circle.svg",
      route: "/my-banks",
      label: "My Banks",
    },
    %{
      imgURL: "/images/transaction.svg",
      route: "/transaction-history",
      label: "Transaction History",
    },
    %{
      imgURL: "/images/money-send.svg",
      route: "/payment-transfer",
      label: "Transfer Funds",
    },
  ]

  def get_sidebar_links, do: @sidebar_links_consts

end
