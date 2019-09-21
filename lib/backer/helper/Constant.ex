defmodule Backer.Constant do
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
    10000
  end

  def minimum_tier() do
    10000
  end

  def default_tier() do
    %{
      "title" => "Standard Backer",
      "description" =>
        "This is the most standard monthly backing cost. Consider it the same as treating us coffee once a month",
      "amount" => "10000"
    }
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
