defmodule MailMasterWeb.ErrorJSONTest do
  use MailMasterWeb.ConnCase, async: true

  test "renders 404" do
    assert MailMasterWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert MailMasterWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
