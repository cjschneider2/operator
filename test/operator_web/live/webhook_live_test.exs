defmodule OperatorWeb.WebhookLiveTest do
  use OperatorWeb.ConnCase

  import Phoenix.LiveViewTest
  import Operator.EventsFixtures

  @create_attrs %{action_id: "7488a646-e31f-11e4-aace-600308960662", description: "some description", name: "some name"}
  @update_attrs %{action_id: "7488a646-e31f-11e4-aace-600308960668", description: "some updated description", name: "some updated name"}
  @invalid_attrs %{action_id: nil, description: nil, name: nil}

  defp create_webhook(_) do
    webhook = webhook_fixture()
    %{webhook: webhook}
  end

  describe "Index" do
    setup [:create_webhook]

    test "lists all webhook", %{conn: conn, webhook: webhook} do
      {:ok, _index_live, html} = live(conn, ~p"/webhook")

      assert html =~ "Listing Webhook"
      assert html =~ webhook.description
    end

    test "saves new webhook", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/webhook")

      assert index_live |> element("a", "New Webhook") |> render_click() =~
               "New Webhook"

      assert_patch(index_live, ~p"/webhook/new")

      assert index_live
             |> form("#webhook-form", webhook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#webhook-form", webhook: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/webhook")

      html = render(index_live)
      assert html =~ "Webhook created successfully"
      assert html =~ "some description"
    end

    test "updates webhook in listing", %{conn: conn, webhook: webhook} do
      {:ok, index_live, _html} = live(conn, ~p"/webhook")

      assert index_live |> element("#webhook-#{webhook.id} a", "Edit") |> render_click() =~
               "Edit Webhook"

      assert_patch(index_live, ~p"/webhook/#{webhook}/edit")

      assert index_live
             |> form("#webhook-form", webhook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#webhook-form", webhook: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/webhook")

      html = render(index_live)
      assert html =~ "Webhook updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes webhook in listing", %{conn: conn, webhook: webhook} do
      {:ok, index_live, _html} = live(conn, ~p"/webhook")

      assert index_live |> element("#webhook-#{webhook.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#webhook-#{webhook.id}")
    end
  end

  describe "Show" do
    setup [:create_webhook]

    test "displays webhook", %{conn: conn, webhook: webhook} do
      {:ok, _show_live, html} = live(conn, ~p"/webhook/#{webhook}")

      assert html =~ "Show Webhook"
      assert html =~ webhook.description
    end

    test "updates webhook within modal", %{conn: conn, webhook: webhook} do
      {:ok, show_live, _html} = live(conn, ~p"/webhook/#{webhook}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Webhook"

      assert_patch(show_live, ~p"/webhook/#{webhook}/show/edit")

      assert show_live
             |> form("#webhook-form", webhook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#webhook-form", webhook: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/webhook/#{webhook}")

      html = render(show_live)
      assert html =~ "Webhook updated successfully"
      assert html =~ "some updated description"
    end
  end
end
