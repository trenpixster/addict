defmodule ExampleApp.UserTest do
  use ExampleApp.ModelCase

  alias ExampleApp.User

  @valid_attrs %{email: "some content", hash: "some content", recovery_hash: "some content", timestamps: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
