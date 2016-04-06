defmodule Addict.ManagerInteractorTest do
  use ExUnit.Case, async: true
  # alias Addict.ManagerInteractor, as: Interactor

#   test "creates a user" do
#     user_params = %{"email" => "test@example.com", "password" => "password", "username" => "test"}
#     assert Interactor.create(user_params, RepoStub, MailerStub, PasswordInteractorStub) == {:ok, %{email: "test@example.com"}}
#   end
#
#   test "validates for invalid params" do
#     user_params = %{}
#     assert catch_throw(Interactor.create(user_params, RepoStub, MailerStub)) == "Unable to create user, invalid hash. Required params: email, password, username"
#   end
#
#   test "validates for nil params" do
#     assert catch_throw(Interactor.create(nil, RepoStub, MailerStub)) == "Unable to create user, invalid hash: nil"
#   end
#
#   test "allows for password to be recovered" do
#     email = "test@example.com"
#     assert Interactor.recover_password(email, RepoStub, MailerStub) == {:ok, %{email: "test@example.com"}}
#   end
#
#   test "handles invalid password recovery requests" do
#     email = "test2@example.com"
#     assert Interactor.recover_password(email, RepoNoMailStub, MailerStub) == {:error, "Unable to send recovery e-mail"}
#   end
#
#   test "resets password" do
#     assert Interactor.reset_password("token123", "valid_password", "valid_password", RepoStub, PasswordInteractorStub) == {:ok, %{email: "test@example.com"}}
#   end
#
#   test "handles reset password with nilled token" do
#     assert Interactor.reset_password(nil, "password", "password", RepoStub) == {:error, "invalid recovery hash"}
#   end
#
#   test "handles reset password with invalid token" do
#     assert Interactor.reset_password("invalidtoken", "password", "password", RepoStub) == {:error, "invalid recovery hash"}
#   end
#
#   test "handles reset password with invalid password confirmation" do
#     assert Interactor.reset_password("invalidtoken", "password", "password_invalid") == {:error, "passwords must match"}
#   end
# end
#
# defmodule PasswordInteractorStub do
#   def generate_hash(_) do
#     "1337h4$h"
#   end
# end
#
# defmodule RepoStub do
#   def create(_) do
#     {:ok, %{email: "test@example.com"}}
#   end
#
#   def add_recovery_hash(_,_) do
#     {:ok, %{email: "test@example.com"}}
#   end
#
#   def find_by_email(_) do
#     {:ok, %{email: "test@example.com"}}
#   end
#
#   def change_password(_,_) do
#     {:ok, %{email: "test@example.com"}}
#   end
#
#   def find_by_recovery_hash("token123") do
#     {:ok, %{email: "test@example.com"}}
#   end
#
#   def find_by_recovery_hash("invalidtoken") do
#     nil
#   end
#
#   def find_by_recovery_hash(nil) do
#     nil
#   end
end

defmodule RepoNoMailStub do
  def find_by_email(_) do
    nil
  end

  def add_recovery_hash(nil,_) do
    {:error, "invalid user"}
  end
end

defmodule MailerStub do
  def send_welcome_email(_) do
    {:ok, %{email: "test@example.com"}}
  end
  def send_password_recovery_email(_) do
    {:ok, %{email: "test@example.com"}}
  end
end
