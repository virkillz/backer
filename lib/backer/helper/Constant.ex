defmodule Backer.Constant do

  def accepted_id_kyc() do
    ["KTP": "ktp", "Passport": "pasport"]
  end

  def payment_method_deposit() do
    ["BCA Transfer": "transfer_bca"]
  end  

  def payment_method_donate() do
    ["Balance": "balance", "BCA Transfer": "transfer_bca"]
  end

  def standard_tier() do
  	[1,2,3,4,5]
  end

  def minimum_deposit() do
  	10000
  end

  def invoice_status() do
  	 ["Paid": "paid", "Unpaid": "unpaid", "Expired": "expired", "Cancelled": "cancelled"]
  end

  def incoming_payment_status() do
    ["Draft", "Approved"]
  end

  def incoming_payment_action() do
    ["Settle Invoice", "Manual Deposit", "Other"]
  end

  def incoming_payment_source() do
    ["BCA Transfer", "Cash", "Credit"]
  end

  def incoming_payment_destination() do
    ["BCA 0372800516 Arif Yuliannur","BCA 0372800318 Nurlaelin Yuliani"]
  end  
end
