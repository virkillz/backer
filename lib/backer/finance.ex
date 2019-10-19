defmodule Backer.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Finance.Invoice
  alias Backer.Finance.IncomingPayment
  alias Backer.Finance.InvoiceDetail
  alias Backer.Account.Donee
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Masterdata.Title
  alias Backer.Content
  alias Backer.Aggregate
  alias Backer.Finance.Settlement

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices do
    Repo.all(Invoice)
  end

  def list_invoices(%{"status" => status}) do
    query = from(i in Invoice, where: i.status == ^status)
    Repo.all(query)
  end

  def list_invoices(%{"backer_id" => backer_id, "donee_id" => donee_id}) do
    query =
      from(i in Invoice,
        where: i.backer_id == ^backer_id,
        where: i.donee_id == ^donee_id,
        order_by: [desc: :id],
        preload: [:invoice_detail]
      )

    Repo.all(query)
  end

  def list_invoices(%{"backer_id" => id}) do
    query =
      from(i in Invoice,
        where: i.backer_id == ^id,
        order_by: [desc: :id],
        preload: [invoice_detail: [], donee: [:backer]]
      )

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

  def get_invoice(id) do
    query =
      from(i in Invoice,
        where: i.id == ^id,
        preload: [[invoice_detail: [donee: [:backer]]], :backer]
      )

    Repo.one(query)
  end

  def get_invoice_compact(id) do
    invoice = get_invoice(id)

    if is_nil(invoice) do
      nil
    else
      payment_method =
        Backer.Constant.default_payment_methods()
        |> Enum.filter(fn x -> x.id == invoice.method end)
        |> List.first()

      %{
        id: invoice.id,
        date: invoice.inserted_at,
        status: invoice.status,
        amount: invoice.amount,
        unique_amount: invoice.unique_amount,
        backer_id: invoice.backer_id,
        backer_name: invoice.backer.display_name,
        backer_email: invoice.backer.email,
        detail: summarize_detail(invoice.invoice_detail),
        payment_method: payment_method
      }
    end
  end

  def summarize_detail(invoice_detail) do
    invoice_detail
    |> Enum.map(fn x ->
      %{
        amount: x.amount,
        donee_name: x.donee.backer.display_name,
        donee_username: x.donee.backer.username,
        month: x.month,
        year: x.year
      }
    end)
    |> Enum.with_index()
  end

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
    |> Ecto.Multi.run(:notification, fn _repo, %{invoice: invoice} ->
      Content.build_notification(:invoice, :waiting_payment, invoice)
    end)
    |> Repo.transaction()
  end

  def create_invoice_detail_donation(invoice, attrs) do
    attr = %{
      "amount" => attrs["amount"],
      "donee_id" => attrs["donee_id"],
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

  def list_new_incoming_payments() do
    query = from(i in IncomingPayment, where: i.status != "Executed", order_by: [desc: :id])
    Repo.all(query)
  end

  def list_incoming_payments(%{"status" => status}, _params) do
    query = from(i in IncomingPayment, where: i.status == ^status, order_by: [desc: :id])
    Repo.paginate(query)
  end

  def list_incoming_payments(%{"status" => status}) do
    query = from(i in IncomingPayment, where: i.status == ^status, order_by: [desc: :id])
    Repo.all(query)
  end

  @doc """
  Returns the list of incoming_payments.

  ## Examples

      iex> list_incoming_payments()
      [%IncomingPayment{}, ...]

  """
  def list_incoming_payments(_params) do
    query = from(i in IncomingPayment, order_by: [desc: :id])
    Repo.paginate(query)
  end

  def list_old_incoming_payments(_params) do
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
      incoming_payment
      |> IncomingPayment.process_executed_deposit_changeset(attrs)

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
        |> Ecto.Multi.run(:backing, fn _repo, _ ->
          create_batch_donation(invoice.id) |> IO.inspect()
        end)
        |> Ecto.Multi.run(:aggregate, fn _repo, %{invoice: invoice} ->
          Aggregate.build_backing_aggregate(invoice.backer_id, invoice.donee_id)
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
      "donee_id" => x.donee_id,
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
    donee = from(p in Donee, preload: [:backer])

    query = from(i in InvoiceDetail, where: i.invoice_id == ^invoice_id, preload: [donee: ^donee])

    Repo.all(query)
  end

  # def test!(id) do
  #  donee = from p in Donee, preload: [:backer]
  #  query = from i in InvoiceDetail, where: i.id == ^id, preload: [donee: ^donee]
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

  def list_my_active_donee(:backer_id, backer_id) do
    today = DateTime.utc_now()

    query =
      from(d in Donation,
        where: d.backer_id == ^backer_id,
        where: d.month == ^today.month,
        where: d.year == ^today.year,
        preload: [donee: [:backer], backer_tier: []]
      )

    Repo.all(query)
    |> Enum.map(fn x ->
      %{
        background: x.donee.background,
        avatar: x.donee.backer.avatar,
        username: x.donee.backer.username,
        backer_count: x.donee.backer_count,
        display_name: x.donee.backer.display_name,
        tagline: x.donee.tagline
      }
    end)
  end

  def count_my_active_donee(:backer_id, backer_id) do
    0
  end

  def count_my_donee(:backer_id, backer_id) do
    query =
      from(d in Donation,
        distinct: d.donee_id,
        where: d.backer_id == ^backer_id,
        select: d.donee_id
      )

    query |> Repo.all() |> Enum.count()
  end

  def list_my_donee(:backer_id, backer_id) do
    query =
      from(d in Donation,
        distinct: d.donee_id,
        where: d.backer_id == ^backer_id,
        preload: [donee: [:backer], backer_tier: []]
      )

    result = Repo.all(query)

    if Enum.count(result) > 0 do
      backing_history = list_backing_history(:backer_id, backer_id)
      Enum.map(result, fn x -> summarize_and_add_active(x, backing_history) end)
    else
      []
    end

    # backing_history = list_backing_history(:backer_id, backer_id)
  end

  def list_incoming_payment(:donee_id, donee_id) do
    query =
      from(i in Invoice,
        where: i.donee_id == ^donee_id,
        preload: [:backer]
      )

    Repo.all(query)
  end

  def summarize_and_add_active(x, backing_history) do
    today = DateTime.utc_now()

    backer_since =
      backing_history
      |> Enum.filter(fn y -> y.donee_id == x.donee_id end)
      |> Enum.min_by(fn z -> z.id end)

    current_donation =
      backing_history
      |> Enum.filter(fn y -> y.donee_id == x.donee_id end)
      |> Enum.filter(fn y -> y.month == today.month && y.year == today.year end)

    summary = %{
      id: x.donee.id,
      display_name: x.donee.backer.display_name,
      avatar: x.donee.backer.avatar,
      background: x.donee.background,
      backer_count: x.donee.backer_count,
      username: x.donee.backer.username,
      tier: x.backer_tier.title,
      backer_since: %{month: backer_since.month, year: backer_since.year}
    }

    if Enum.count(current_donation) > 0 do
      Map.put(summary, :status, "Active")
    else
      Map.put(summary, :status, "Inactive")
    end
  end

  def list_backing_history(:backer_id, backer_id) do
    query =
      from(d in Donation,
        where: d.backer_id == ^backer_id,
        preload: [donee: [:backer]]
      )

    result = Repo.all(query)
  end

  @doc """
  Returns the list of donations.

  ## Examples

      iex> list_donations()
      [%Donation{}, ...]

  """

  def list_all_backerfor(%{"backer_id" => id}) do
    query =
      from(d in Donation,
        join: p in Donee,
        join: b in Backerz,
        join: t in Title,
        on: p.title_id == t.id,
        on: p.backer_id == b.id,
        on: d.donee_id == p.id,
        where: d.backer_id == ^id,
        select: %{
          donee_id: d.donee_id,
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
  List all active backers for one particular donee

  ## Examples

      iex> list_donations()
      [%Donation{}, ...]

  """

  def list_active_backers(%{"donee_id" => id}) do
    {year, month, _day} = Date.utc_today() |> Date.to_erl()

    query =
      from(d in Donation,
        join: b in Backerz,
        on: d.backer_id == b.id,
        where: d.donee_id == ^id,
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

  def list_active_backers(:donee_id, donee_id) do
    today = DateTime.utc_now()

    query =
      from(d in Donation,
        where: d.donee_id == ^donee_id,
        where: d.month == ^today.month,
        where: d.year == ^today.year,
        order_by: [desc: d.amount],
        preload: [:backer, :backer_tier]
      )

    Repo.all(query)
    |> Enum.map(fn x ->
      %{
        avatar: x.backer.avatar,
        username: x.backer.username,
        tier: x.backer_tier.title,
        display_name: x.backer.display_name
      }
    end)
  end

  def list_all_backers(%{"donee_id" => id}) do
    query =
      from(d in Donation,
        join: b in Backerz,
        on: d.backer_id == b.id,
        where: d.donee_id == ^id and d.is_executed == true,
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
    active_backer = list_active_backers(%{"donee_id" => id})

    aggregate_backers = Enum.map(all_backer, fn x -> aggregate_backers_list(active_backer, x) end)
  end

  defp aggregate_backers_list(list, backer) do
    result = Enum.find(list, fn x -> x.backer_id == backer.backer_id end)

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
        join: p in Donee,
        join: b in Backerz,
        join: t in Title,
        on: p.title_id == t.id,
        on: p.backer_id == b.id,
        on: d.donee_id == p.id,
        where: d.backer_id == ^id,
        where: d.month == ^month and d.year == ^year,
        select: %{
          donee_id: d.donee_id,
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
        join: p in Donee,
        join: b in Backerz,
        join: t in Title,
        on: p.title_id == t.id,
        on: p.backer_id == b.id,
        on: d.donee_id == p.id,
        where: d.backer_id == ^id,
        select: %{
          donee_id: d.donee_id,
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

  def list_donations(%{"backer_id" => backer_id, "donee_id" => donee_id}) do
    query =
      from(d in Donation,
        where: d.backer_id == ^backer_id,
        where: d.donee_id == ^donee_id,
        order_by: d.id,
        preload: [:backer_tier]
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

  def is_backer_have_donations_ever?(backer_id, donee_id) do
    query =
      from(d in Donation,
        where: d.backer_id == ^backer_id,
        where: d.donee_id == ^donee_id,
        order_by: [desc: d.id],
        limit: 1
      )

    result = Repo.one(query)

    not is_nil(result)
  end

  def is_backer_have_active_donations?(backer_id, donee_id) do
    now = DateTime.utc_now()

    query =
      from(d in Donation,
        where: d.backer_id == ^backer_id,
        where: d.donee_id == ^donee_id,
        where: d.month == ^now.month,
        where: d.year == ^now.year,
        order_by: [desc: d.id],
        limit: 1
      )

    result = Repo.one(query)

    #  WRONG LOGIC but afraid to delete. What was I thinking??
    # if is_nil(result) do
    #   false
    # else
    #   {ok, last_donation} = NaiveDateTime.new(result.year, result.month, 1, 0, 0, 0)
    #   {ok, current_time} = NaiveDateTime.new(now.year, now.month, 1, 0, 0, 0)
    #   current_time >= last_donation
    # end

    not is_nil(result)
  end

  def is_backer_have_unpaid_invoice?(backer_id, donee_id) do
    query =
      from(i in Invoice,
        where: i.status == "unpaid",
        where: i.donee_id == ^donee_id,
        where: i.backer_id == ^backer_id
      )

    Enum.count(Repo.all(query)) > 0
  end

  def expiry_unpaid_invoice() do
    IO.puts("Scan expired invoices...")
    now = NaiveDateTime.utc_now()

    result =
      list_invoice_with_(:status, :unpaid)
      |> Enum.filter(fn x -> NaiveDateTime.diff(now, x.inserted_at) > 86400 end)
      |> Enum.map(fn x -> update_invoice(x, %{"status" => "expired"}) end)
      |> Enum.count()

    IO.puts("#{result} invoice/s changed to expired status")
    {:ok, result}
  end

  def list_invoice_with_(:status, :unpaid) do
    query =
      from(i in Invoice,
        where: i.status == "unpaid"
      )

    Repo.all(query)
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

  @doc """
  Returns the list of settlements.

  ## Examples

      iex> list_settlements()
      [%Settlement{}, ...]

  """
  def list_settlements do
    query =
      from(s in Settlement,
        preload: [donee: [:backer]]
      )

    Repo.all(query)
  end

  def list_unsettled_invoice do
    query =
      from(i in Invoice,
        where: i.settlement_status == "unpaid",
        where: i.status == "paid",
        preload: [donee: [:backer]]
      )

    Repo.all(query)
  end

  def list_unsettled_invoice_by(:donee_id, donee_id) do
    query =
      from(i in Invoice,
        where: i.settlement_status == "unpaid",
        where: i.status == "paid",
        where: i.donee_id == ^donee_id
      )

    Repo.all(query)
  end

  def list_unsettled_donee do
    invoices = list_unsettled_invoice

    donee =
      Enum.uniq_by(invoices, fn x -> x.donee_id end)
      |> Enum.map(fn x ->
        %{
          donee_id: x.donee_id,
          avatar: x.donee.backer.avatar,
          display_name: x.donee.backer.display_name,
          username: x.donee.backer.username
        }
      end)
      |> Enum.map(fn x ->
        x
        |> Map.put(
          :amount_total,
          invoices
          |> Enum.filter(fn y -> y.donee_id == x.donee_id end)
          |> Enum.reduce(0, fn z, acc -> acc + z.amount end)
        )
        |> Map.put(
          :oldest_invoice_date,
          invoices
          |> Enum.filter(fn y -> y.donee_id == x.donee_id end)
          |> get_oldest_date
        )
      end)
  end

  defp get_oldest_date(list) do
    oldest = Enum.min_by(list, fn x -> x.id end)
    oldest.inserted_at
  end

  def get_unsettled_donee(donee_id) do
    invoices = list_unsettled_invoice_by(:donee_id, donee_id)
  end

  @doc """
  Gets a single settlement.

  Raises `Ecto.NoResultsError` if the Settlement does not exist.

  ## Examples

      iex> get_settlement!(123)
      %Settlement{}

      iex> get_settlement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_settlement!(id), do: Repo.get!(Settlement, id)

  @doc """
  Creates a settlement.

  ## Examples

      iex> create_settlement(%{field: value})
      {:ok, %Settlement{}}

      iex> create_settlement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_settlement(attrs \\ %{}) do
    %Settlement{}
    |> Settlement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a settlement.

  ## Examples

      iex> create_settlement(%{field: value})
      {:ok, %Settlement{}}

      iex> create_settlement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def initiate_settlement(attrs \\ %{}) do
    %Settlement{}
    |> Settlement.changeset_new(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a settlement.

  ## Examples

      iex> update_settlement(settlement, %{field: new_value})
      {:ok, %Settlement{}}

      iex> update_settlement(settlement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_settlement(%Settlement{} = settlement, attrs) do
    settlement
    |> Settlement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Settlement.

  ## Examples

      iex> delete_settlement(settlement)
      {:ok, %Settlement{}}

      iex> delete_settlement(settlement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_settlement(%Settlement{} = settlement) do
    Repo.delete(settlement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking settlement changes.

  ## Examples

      iex> change_settlement(settlement)
      %Ecto.Changeset{source: %Settlement{}}

  """
  def change_settlement(%Settlement{} = settlement) do
    Settlement.changeset(settlement, %{})
  end

  alias Backer.Finance.SettlementDetail

  @doc """
  Returns the list of settlement_details.

  ## Examples

      iex> list_settlement_details()
      [%SettlementDetail{}, ...]

  """
  def list_settlement_details do
    Repo.all(SettlementDetail)
  end

  @doc """
  Gets a single settlement_detail.

  Raises `Ecto.NoResultsError` if the Settlement detail does not exist.

  ## Examples

      iex> get_settlement_detail!(123)
      %SettlementDetail{}

      iex> get_settlement_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_settlement_detail!(id), do: Repo.get!(SettlementDetail, id)

  @doc """
  Creates a settlement_detail.

  ## Examples

      iex> create_settlement_detail(%{field: value})
      {:ok, %SettlementDetail{}}

      iex> create_settlement_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_settlement_detail(attrs \\ %{}) do
    %SettlementDetail{}
    |> SettlementDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a settlement_detail.

  ## Examples

      iex> update_settlement_detail(settlement_detail, %{field: new_value})
      {:ok, %SettlementDetail{}}

      iex> update_settlement_detail(settlement_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_settlement_detail(%SettlementDetail{} = settlement_detail, attrs) do
    settlement_detail
    |> SettlementDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SettlementDetail.

  ## Examples

      iex> delete_settlement_detail(settlement_detail)
      {:ok, %SettlementDetail{}}

      iex> delete_settlement_detail(settlement_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_settlement_detail(%SettlementDetail{} = settlement_detail) do
    Repo.delete(settlement_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking settlement_detail changes.

  ## Examples

      iex> change_settlement_detail(settlement_detail)
      %Ecto.Changeset{source: %SettlementDetail{}}

  """
  def change_settlement_detail(%SettlementDetail{} = settlement_detail) do
    SettlementDetail.changeset(settlement_detail, %{})
  end
end
