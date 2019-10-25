defmodule Backer.Constant do
  @moduledoc """
    Constant
  """

  def accepted_id_kyc() do
    [KTP: "ktp", Passport: "pasport"]
  end

  def payment_method_deposit() do
    ["BCA Transfer": "transfer_bca"]
  end

  def payment_method_donate() do
    [Balance: "balance", "BCA Transfer": "transfer_bca"]
  end

  def standard_tier() do
    [Public: 0, "Tier 1": 1, "Tier 2": 2, "Tier 3": 3, "Tier 4": 4, "Tier 5": 5]
  end

  def minimum_deposit() do
    10_000
  end

  def minimum_tier() do
    10_000
  end

  def default_platform_fee do
    0.08
  end

  def calculate_platform_fee(amount, _donee_id) do
    fee = trunc(default_platform_fee() * amount)
    {fee, amount - fee}
  end

  def default_payment_methods do
    [
      %{
        id: "transfer_bca",
        name: "BCA",
        logo: "/assets/images/logo/bca.png",
        description: "<div><span class=\"font-bold\">Acc:</span> 0372800516</div>"
      },
      %{
        id: "transfer_bni",
        name: "BNI",
        logo: "/assets/images/logo/bni.png",
        description:
          "<div><span class=\"font-bold\">Acc:</span> 0372800516</div> <div><span class=\"font-bold\">Nama:</span> PT Backer Kreasi Republik</div>"
      },
      %{
        id: "transfer_mandiri",
        name: "MANDIRI",
        logo: "/assets/images/logo/mandiri.png",
        description: "<div><span class=\"font-bold\">Acc:</span> 0372800516</div>"
      }
    ]
  end

  def default_tiers do
    [
      %{
        "amount" => 10_000,
        "description" => "Equal to a cup of tea. Treat us once in a month maybe?",
        "title" => "Tea Backer"
      },
      %{
        "amount" => 20_000,
        "description" => "Equal to a cup of coffee. Treat us once in a month maybe?",
        "title" => "Coffee Backer"
      },
      %{
        "amount" => 50_000,
        "description" => "You treat us decent meal, once a month. Really appreciate it.",
        "title" => "Meal Backer"
      },
      %{
        "amount" => 100_000,
        "description" => "We can buy martabak once a month. Thanks!",
        "title" => "Martabak Backer"
      },
      %{
        "amount" => 200_000,
        "description" => "Equal to buy us pizza one a month. Great Thanks!",
        "title" => "Pizza Backer"
      }
    ]
  end

  def invoice_status() do
    [Unpaid: "unpaid", Expired: "expired", Cancelled: "cancelled"]
  end

  def profile_generator() do
    [
      "An Internet wanderer.",
      "An Internet nomads.",
      "Self proclaimed beautiful human.",
      "A generous backer in the making",
      "Looking for interesting project to be backed!",
      "Show me an interesting Donee to backed."
    ]
  end

  def incoming_payment_status() do
    ["Draft", "Approved"]
  end

  def incoming_payment_action() do
    ["Settle Invoice", "Deposit", "Other"]
  end

  def incoming_payment_source() do
    ["BCA Transfer", "Cash", "Credit"]
  end

  def incoming_payment_destination() do
    ["BCA 0372800516 Arif Yuliannur", "BCA 0372800318 Nurlaelin Yuliani"]
  end

  def try do
    duplicate(5)
  end

  def duplicate(0) do
    IO.puts("Habis 0!")
  end

  def duplicate(i) do
    hasil = i - 1
    IO.puts(i)
    duplicate(hasil)
  end
end
