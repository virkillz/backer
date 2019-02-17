defmodule Backer.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Finance.Invoice
  alias Backer.Finance.IncomingPayment
  alias Backer.Finance.InvoiceDetail
  alias Backer.Account.Pledger
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Masterdata.Title

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices do
    Repo.all(Invoice)
  end

  def list_invoices(%{"status" => "not_paid"}) do
    query = from(i in Invoice, where: i.status != "paid")
    Repo.all(query)
  end

  def list_invoices(%{"backer_id" => id}) do
    query = from(i in Invoice, where: i.backer_id == ^id, order_by: [desc: :id])
    Repo.all(query)
  end

  def list_invoices(params) do
    Repo.paginate(Invoice, params)
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(id), do: Repo.get!(Invoice, id) |> Repo.preload(:backer)

  def get_invoice(id), do: Repo.get(Invoice, id)

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(%{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deposit_invoice(attrs \\ %{}) do
    invoice_changeset = %Invoice{} |> Invoice.changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:invoice, invoice_changeset)
    |> Ecto.Multi.run(:user, fn _repo, %{invoice: invoice} ->
      create_invoice_detail_deposit(invoice)
    end)
    |> Repo.transaction()
  end

  def create_donation_invoice(attrs \\ %{}) do
    invoice_changeset = %Invoice{} |> Invoice.donation_changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:invoice, invoice_changeset)
    |> Ecto.Multi.run(:user, fn _repo, %{invoice: invoice} ->
      create_invoice_detail_donation(invoice, attrs)
    end)
    |> Repo.transaction()
  end

  def create_invoice_detail_donation(invoice, attrs) do
    attr = %{
      "amount" => attrs["amount"],
      "pledger_id" => attrs["pledger_id"],
      "type" => "donate",
      "backer_id" => attrs["backer_id"],
      "invoice_id" => invoice.id
    }

    {i, _} = attrs["month"] |> Integer.parse()
    insert_donation_detail(i, attr)
  end

  def insert_donation_detail(0, _attr) do
    {:ok, "terserah"}
  end

  def insert_donation_detail(i, attr) do
    next = i - 1

    {year, month, _day} = Date.utc_today() |> Date.add(30 * next) |> Date.to_erl()

    attrs = attr |> Map.put("month", month) |> Map.put("year", year)

    %InvoiceDetail{}
    |> InvoiceDetail.changeset(attrs)
    |> Repo.insert()

    insert_donation_detail(next, attr)
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{source: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice) do
    Invoice.changeset(invoice, %{})
  end

  @doc """
  Returns the list of incoming_payments.

  ## Examples

      iex> list_incoming_payments()
      [%IncomingPayment{}, ...]

  """
  def list_incoming_payments(params) do
    query = from(i in IncomingPayment, order_by: [desc: :id])
    Repo.paginate(query)
  end

  def list_new_incoming_payments() do
    query = from(i in IncomingPayment, where: i.status != "Executed", order_by: [desc: :id])
    Repo.all(query)
  end

  def list_incoming_payments(%{"status" => status}, params) do
    query = from(i in IncomingPayment, where: i.status == ^status, order_by: [desc: :id])
    Repo.paginate(query)
  end

  def list_incoming_payments(%{"status" => status}) do
    query = from(i in IncomingPayment, where: i.status == ^status, order_by: [desc: :id])
    Repo.all(query)
  end

  def list_old_incoming_payments(params) do
    query = from(i in IncomingPayment, where: i.status == "Executed", order_by: [desc: :id])
    Repo.paginate(query)
  end

  def count_incoming_payment_approval do
    query = from(i in IncomingPayment, where: i.status == "Approved", select: count(i.id))
    Repo.one(query)
  end

  def count_incoming_payment_pending do
    query = from(i in IncomingPayment, where: i.status == "Revision Request", select: count(i.id))
    Repo.one(query)
  end

  @doc """
  Gets a single incoming_payment.

  Raises `Ecto.NoResultsError` if the Incoming payment does not exist.

  ## Examples

      iex> get_incoming_payment!(123)
      %IncomingPayment{}

      iex> get_incoming_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_incoming_payment!(id), do: Repo.get!(IncomingPayment, id)

  @doc """
  Creates a incoming_payment.

  ## Examples

      iex> create_incoming_payment(%{field: value})
      {:ok, %IncomingPayment{}}

      iex> create_incoming_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_incoming_payment(attrs \\ %{}) do
    %IncomingPayment{}
    |> IncomingPayment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a incoming_payment.

  ## Examples

      iex> update_incoming_payment(incoming_payment, %{field: new_value})
      {:ok, %IncomingPayment{}}

      iex> update_incoming_payment(incoming_payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_incoming_payment(%IncomingPayment{} = incoming_payment, attrs) do
    incoming_payment
    |> IncomingPayment.changeset(attrs)
    |> Repo.update()
  end

  def process_incoming_payment(
        %IncomingPayment{action: "Other"} = incoming_payment,
        %{"status" => "Executed"} = attrs
      ) do
    incoming_payment
    |> IncomingPayment.process_executed_other_changeset(attrs)
    |> Repo.update()
  end

  def process_incoming_payment(
        %IncomingPayment{action: "Deposit"} = incoming_payment,
        %{"status" => "Executed"} = attrs
      ) do
    incoming_payment_changeset =
      incoming_payment |> IncomingPayment.process_executed_deposit_changeset(attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:incoming_payment, incoming_payment_changeset)
    |> Ecto.Multi.run(:mutation, fn _repo, %{incoming_payment: updated_incoming_payment} ->
      create_mutation_deposit(updated_incoming_payment, updated_incoming_payment.backer_id)
    end)
    |> Repo.transaction()
  end

  def process_incoming_payment(
        %IncomingPayment{action: "Settle Invoice"} = incoming_payment,
        %{"status" => "Executed"} = attrs
      ) do
    pay_invoice_attr = %{"status" => "paid"}
    invoice = get_invoice(incoming_payment.invoice_id)
    invoice_changeset = Invoice.change_status_changeset(invoice, pay_invoice_attr)

    case invoice.type do
      "deposit" ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :incoming_payment,
          IncomingPayment.process_executed_settle_invoice_changeset(incoming_payment, attrs)
        )
        |> Ecto.Multi.update(:invoice, invoice_changeset)
        |> Ecto.Multi.run(:mutation, fn _repo, %{incoming_payment: _updated_incoming_payment} ->
          create_mutation_deposit(incoming_payment, invoice.backer_id)
        end)
        |> Repo.transaction()

      "backing" ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :incoming_payment,
          IncomingPayment.process_executed_settle_invoice_changeset(incoming_payment, attrs)
        )
        |> Ecto.Multi.update(:invoice, invoice_changeset)
        |> Ecto.Multi.run(:backing, fn _ ->
          create_batch_donation(invoice.id)
          # {:error, %{"somehow" => "wrong again"}}
        end)
        |> Repo.transaction()
    end
  end

  defp create_batch_donation(invoice_id) do
    invoice_details = list_invoice_details(%{"invoice_id" => invoice_id})

    case Enum.each(invoice_details, fn x -> create_donation_from_invoice_detail(x) end) do
      :ok -> {:ok, "executed"}
      _other -> {:error, "failed to create"}
    end
  end

  defp create_donation_from_invoice_detail(x) do
    attrs = %{
      "amount" => x.amount,
      "tier" => 1,
      "backer_id" => x.backer_id,
      "pledger_id" => x.pledger_id,
      "invoice_id" => x.invoice_id,
      "month" => x.month,
      "year" => x.year
    }

    create_donation(attrs)
  end

  def process_incoming_payment(
        %IncomingPayment{} = incoming_payment,
        %{"status" => "Revision Request"} = attrs
      ) do
    incoming_payment
    |> IncomingPayment.process_revision_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a IncomingPayment.

  ## Examples

      iex> delete_incoming_payment(incoming_payment)
      {:ok, %IncomingPayment{}}

      iex> delete_incoming_payment(incoming_payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_incoming_payment(%IncomingPayment{} = incoming_payment) do
    Repo.delete(incoming_payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking incoming_payment changes.

  ## Examples

      iex> change_incoming_payment(incoming_payment)
      %Ecto.Changeset{source: %IncomingPayment{}}

  """
  def change_incoming_payment(%IncomingPayment{} = incoming_payment) do
    IncomingPayment.changeset(incoming_payment, %{})
  end

  @doc """
  Returns the list of invoice_details.

  ## Examples

      iex> list_invoice_details()
      [%InvoiceDetail{}, ...]

  """
  def list_invoice_details(params) do
    query = from(i in InvoiceDetail, order_by: [desc: :id])
    Repo.paginate(query, params)
  end

  def list_invoice_details(%{"invoice_id" => invoice_id}) do
    query = from(i in InvoiceDetail, where: i.invoice_id == ^invoice_id)
    Repo.all(query)
  end

  @doc """
  Gets a single invoice_detail.

  Raises `Ecto.NoResultsError` if the Invoice detail does not exist.

  ## Examples

      iex> get_invoice_detail!(123)
      %InvoiceDetail{}

      iex> get_invoice_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice_detail!(id), do: Repo.get!(InvoiceDetail, id)

  def get_invoice_detail(%{"invoice_id" => invoice_id}) do
    pledger = from(p in Pledger, preload: [:backer])

    query =
      from(i in InvoiceDetail, where: i.invoice_id == ^invoice_id, preload: [pledger: ^pledger])

    Repo.all(query)
  end

  # def test!(id) do 
  #  pledger = from p in Pledger, preload: [:backer]
  #  query = from i in InvoiceDetail, where: i.id == ^id, preload: [pledger: ^pledger]
  #  Repo.all(query)
  # end

  @doc """
  Creates a invoice_detail.

  ## Examples

      iex> create_invoice_detail(%{field: value})
      {:ok, %InvoiceDetail{}}

      iex> create_invoice_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice_detail(attrs \\ %{}) do
    %InvoiceDetail{}
    |> InvoiceDetail.changeset(attrs)
    |> Repo.insert()
  end

  defp create_invoice_detail_deposit(invoice) do
    attrs = %{
      "amount" => invoice.amount,
      "type" => "deposit",
      "backer_id" => invoice.backer_id,
      "invoice_id" => invoice.id
    }

    %InvoiceDetail{}
    |> InvoiceDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invoice_detail.

  ## Examples

      iex> update_invoice_detail(invoice_detail, %{field: new_value})
      {:ok, %InvoiceDetail{}}

      iex> update_invoice_detail(invoice_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice_detail(%InvoiceDetail{} = invoice_detail, attrs) do
    invoice_detail
    |> InvoiceDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a InvoiceDetail.

  ## Examples

      iex> delete_invoice_detail(invoice_detail)
      {:ok, %InvoiceDetail{}}

      iex> delete_invoice_detail(invoice_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice_detail(%InvoiceDetail{} = invoice_detail) do
    Repo.delete(invoice_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice_detail changes.

  ## Examples

      iex> change_invoice_detail(invoice_detail)
      %Ecto.Changeset{source: %InvoiceDetail{}}

  """
  def change_invoice_detail(%InvoiceDetail{} = invoice_detail) do
    InvoiceDetail.changeset(invoice_detail, %{})
  end

  alias Backer.Finance.Donation

  @doc """
  Returns the list of donations.

  ## Examples

      iex> list_donations()
      [%Donation{}, ...]

  """

  def list_all_backerfor(%{"backer_id" => id}) do
    query =
      from(d in Donation,
        join: p in Pledger,
        join: b in Backerz,
        join: t in Title,
        on: p.title_id == t.id,
        on: p.backer_id == b.id,
        on: d.pledger_id == p.id,
        where: d.backer_id == ^id,
        select: %{
          pledger_id: d.pledger_id,
          background: p.background,
          display_name: b.display_name,
          avatar: b.avatar,
          username: b.username,
          title: t.name
        },
        distinct: true
      )

    Repo.all(query)
  end

  @doc """
  List all active backers for one particular pledger

  ## Examples

      iex> list_donations()
      [%Donation{}, ...]

  """

  def list_active_backers(%{"pledger_id" => id}) do
    {year, month, _day} = Date.utc_today() |> Date.to_erl()

    query =
      from(d in Donation,
        join: b in Backerz,
        on: d.backer_id == b.id,
        where: d.pledger_id == ^id,
        where: d.month == ^month and d.year == ^year,
        select: %{
          backer_id: d.backer_id,
          username: b.username,
          avatar: b.avatar,
          display_name: b.display_name,
          tier: d.tier
        },
        distinct: true
      )

    Repo.all(query)
  end

  def list_all_backers(%{"pledger_id" => id}) do
    query =
      from(d in Donation,
        join: b in Backerz,
        on: d.backer_id == b.id,
        where: d.pledger_id == ^id and d.is_executed == true,
        group_by: [d.backer_id, b.avatar, b.display_name, b.username],
        select: %{
          backer_id: d.backer_id,
          amount: sum(d.amount),
          avatar: b.avatar,
          display_name: b.display_name,
          username: b.username
        }
      )

    all_backer = Repo.all(query)
    active_backer = list_active_backers(%{"pledger_id" => id})

    aggregate_backers = Enum.map(all_backer, fn x -> aggregate_backers_list(active_backer, x) end)
  end

  defp aggregate_backers_list(list, backer) do
    result = Enum.find(list, fn x -> x.backer_id == backer.backer_id end) |> IO.inspect()

    if result != nil do
      Map.put(backer, :status, "active") |> Map.put(:tier, result.tier)
    else
      Map.put(backer, :status, "inactive") |> Map.put(:tier, "-")
    end
  end

  def list_active_backerfor(%{"backer_id" => id}) do
    {year, month, _day} = Date.utc_today() |> Date.to_erl()

    query =
      from(d in Donation,
        join: p in Pledger,
        join: b in Backerz,
        join: t in Title,
        on: p.title_id == t.id,
        on: p.backer_id == b.id,
        on: d.pledger_id == p.id,
        where: d.backer_id == ^id,
        where: d.month == ^month and d.year == ^year,
        select: %{
          pledger_id: d.pledger_id,
          background: p.background,
          display_name: b.display_name,
          avatar: b.avatar,
          username: b.username,
          title: t.name
        },
        distinct: true
      )

    Repo.all(query)
  end

  def list_all_backerfor(%{"backer_id" => id, "limit" => limit}) do
    query =
      from(d in Donation,
        join: p in Pledger,
        join: b in Backerz,
        join: t in Title,
        on: p.title_id == t.id,
        on: p.backer_id == b.id,
        on: d.pledger_id == p.id,
        where: d.backer_id == ^id,
        select: %{
          pledger_id: d.pledger_id,
          background: p.background,
          display_name: b.display_name,
          avatar: b.avatar,
          username: b.username,
          title: t.name
        },
        distinct: true,
        limit: ^limit
      )

    Repo.all(query)
  end

  def list_donations(params) do
    Repo.paginate(Donation, params)
  end

  @doc """
  Gets a single donation.

  Raises `Ecto.NoResultsError` if the Donation does not exist.

  ## Examples

      iex> get_donation!(123)
      %Donation{}

      iex> get_donation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_donation!(id), do: Repo.get!(Donation, id)

  @doc """
  Creates a donation.

  ## Examples

      iex> create_donation(%{field: value})
      {:ok, %Donation{}}

      iex> create_donation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_donation(attrs \\ %{}) do
    %Donation{}
    |> Donation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a donation.

  ## Examples

      iex> update_donation(donation, %{field: new_value})
      {:ok, %Donation{}}

      iex> update_donation(donation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_donation(%Donation{} = donation, attrs) do
    donation
    |> Donation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Donation.

  ## Examples

      iex> delete_donation(donation)
      {:ok, %Donation{}}

      iex> delete_donation(donation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_donation(%Donation{} = donation) do
    Repo.delete(donation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking donation changes.

  ## Examples

      iex> change_donation(donation)
      %Ecto.Changeset{source: %Donation{}}

  """
  def change_donation(%Donation{} = donation) do
    Donation.changeset(donation, %{})
  end

  alias Backer.Finance.Mutation

  @doc """
  Returns the list of mutations.

  ## Examples

      iex> list_mutations()
      [%Mutation{}, ...]

  """

  def list_mutations() do
    query = from(m in Mutation, order_by: [desc: :id])

    Repo.all(query)
  end

  def list_mutations(params) do
    query = from(m in Mutation, order_by: [desc: :id])

    Repo.paginate(query, params)
  end

  @doc """
  Gets a single mutation.

  Raises `Ecto.NoResultsError` if the Mutation does not exist.

  ## Examples

      iex> get_mutation!(123)
      %Mutation{}

      iex> get_mutation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mutation!(id), do: Repo.get!(Mutation, id)

  @doc """
  Creates a mutation.

  ## Examples

      iex> create_mutation(%{field: value})
      {:ok, %Mutation{}}

      iex> create_mutation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mutation(attrs \\ %{}) do
    %Mutation{}
    |> Mutation.changeset(attrs)
    |> Repo.insert()
  end

  def get_balance(%{"backer_id" => id}) do
    query =
      from(m in Mutation,
        where: m.backer_id == ^id,
        order_by: [desc: :id],
        limit: 1,
        select: %{balance: m.balance}
      )

    result = Repo.one(query)

    if result == nil do
      0
    else
      result.balance
    end
  end

  defp create_mutation_deposit(incoming_payment, backer_id) do
    balance = get_last_balance(backer_id) + incoming_payment.amount

    attrs = %{
      "asset" => "IDR",
      "backer_id" => backer_id,
      "backer_id_string" => Integer.to_string(backer_id),
      "debit" => incoming_payment.amount,
      "balance" => balance,
      "action_type" => "manual",
      "action_by" => incoming_payment.excecutor_id,
      "approved_by" => incoming_payment.checker_id,
      "reason" => "deposit"
    }

    %Mutation{}
    |> Mutation.changeset(attrs)
    |> Repo.insert()
  end

  def get_last_balance(backer_id) do
    query =
      from(m in Mutation, where: m.backer_id == ^backer_id, order_by: [desc: m.id], limit: 1)

    case Repo.one(query) do
      nil -> 0
      result -> result.balance
    end
  end

  @doc """
  Updates a mutation.

  ## Examples

      iex> update_mutation(mutation, %{field: new_value})
      {:ok, %Mutation{}}

      iex> update_mutation(mutation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mutation(%Mutation{} = mutation, attrs) do
    mutation
    |> Mutation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Mutation.

  ## Examples

      iex> delete_mutation(mutation)
      {:ok, %Mutation{}}

      iex> delete_mutation(mutation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mutation(%Mutation{} = mutation) do
    Repo.delete(mutation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mutation changes.

  ## Examples

      iex> change_mutation(mutation)
      %Ecto.Changeset{source: %Mutation{}}

  """
  def change_mutation(%Mutation{} = mutation) do
    Mutation.changeset(mutation, %{})
  end

  alias Backer.Finance.Withdrawal

  @doc """
  Returns the list of withdrawals.

  ## Examples

      iex> list_withdrawals()
      [%Withdrawal{}, ...]

  """
  def list_withdrawals(params) do
    Repo.paginate(Withdrawal, params)
  end

  @doc """
  Gets a single withdrawal.

  Raises `Ecto.NoResultsError` if the Withdrawal does not exist.

  ## Examples

      iex> get_withdrawal!(123)
      %Withdrawal{}

      iex> get_withdrawal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_withdrawal!(id), do: Repo.get!(Withdrawal, id)

  @doc """
  Creates a withdrawal.

  ## Examples

      iex> create_withdrawal(%{field: value})
      {:ok, %Withdrawal{}}

      iex> create_withdrawal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_withdrawal(attrs \\ %{}) do
    %Withdrawal{}
    |> Withdrawal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a withdrawal.

  ## Examples

      iex> update_withdrawal(withdrawal, %{field: new_value})
      {:ok, %Withdrawal{}}

      iex> update_withdrawal(withdrawal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_withdrawal(%Withdrawal{} = withdrawal, attrs) do
    withdrawal
    |> Withdrawal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Withdrawal.

  ## Examples

      iex> delete_withdrawal(withdrawal)
      {:ok, %Withdrawal{}}

      iex> delete_withdrawal(withdrawal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_withdrawal(%Withdrawal{} = withdrawal) do
    Repo.delete(withdrawal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking withdrawal changes.

  ## Examples

      iex> change_withdrawal(withdrawal)
      %Ecto.Changeset{source: %Withdrawal{}}

  """
  def change_withdrawal(%Withdrawal{} = withdrawal) do
    Withdrawal.changeset(withdrawal, %{})
  end
end
