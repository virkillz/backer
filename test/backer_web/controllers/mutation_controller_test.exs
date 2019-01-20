defmodule BackerWeb.MutationControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Finance

  @create_attrs %{action_type: "some action_type", asset: "some asset", backer_id_string: "some backer_id_string", balance: 42, credit: 42, debit: 42, frozen_amount: 42, reason: "some reason", ref_id: 42}
  @update_attrs %{action_type: "some updated action_type", asset: "some updated asset", backer_id_string: "some updated backer_id_string", balance: 43, credit: 43, debit: 43, frozen_amount: 43, reason: "some updated reason", ref_id: 43}
  @invalid_attrs %{action_type: nil, asset: nil, backer_id_string: nil, balance: nil, credit: nil, debit: nil, frozen_amount: nil, reason: nil, ref_id: nil}

  def fixture(:mutation) do
    {:ok, mutation} = Finance.create_mutation(@create_attrs)
    mutation
  end

  describe "index" do
    test "lists all mutations", %{conn: conn} do
      conn = get conn, mutation_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Mutations"
    end
  end

  describe "new mutation" do
    test "renders form", %{conn: conn} do
      conn = get conn, mutation_path(conn, :new)
      assert html_response(conn, 200) =~ "New Mutation"
    end
  end

  describe "create mutation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, mutation_path(conn, :create), mutation: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == mutation_path(conn, :show, id)

      conn = get conn, mutation_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Mutation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, mutation_path(conn, :create), mutation: @invalid_attrs
      assert html_response(conn, 200) =~ "New Mutation"
    end
  end

  describe "edit mutation" do
    setup [:create_mutation]

    test "renders form for editing chosen mutation", %{conn: conn, mutation: mutation} do
      conn = get conn, mutation_path(conn, :edit, mutation)
      assert html_response(conn, 200) =~ "Edit Mutation"
    end
  end

  describe "update mutation" do
    setup [:create_mutation]

    test "redirects when data is valid", %{conn: conn, mutation: mutation} do
      conn = put conn, mutation_path(conn, :update, mutation), mutation: @update_attrs
      assert redirected_to(conn) == mutation_path(conn, :show, mutation)

      conn = get conn, mutation_path(conn, :show, mutation)
      assert html_response(conn, 200) =~ "some updated action_type"
    end

    test "renders errors when data is invalid", %{conn: conn, mutation: mutation} do
      conn = put conn, mutation_path(conn, :update, mutation), mutation: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Mutation"
    end
  end

  describe "delete mutation" do
    setup [:create_mutation]

    test "deletes chosen mutation", %{conn: conn, mutation: mutation} do
      conn = delete conn, mutation_path(conn, :delete, mutation)
      assert redirected_to(conn) == mutation_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, mutation_path(conn, :show, mutation)
      end
    end
  end

  defp create_mutation(_) do
    mutation = fixture(:mutation)
    {:ok, mutation: mutation}
  end
end
