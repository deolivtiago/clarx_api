defmodule ClarxApi.AccountsTest do
  use ClarxApi.DataCase, async: true

  import ClarxApi.Factories.UserFactory

  alias Argon2
  alias ClarxApi.Accounts
  alias ClarxApi.Accounts.User
  alias Ecto.Changeset

  setup do
    :user
    |> params_for()
    |> then(&{:ok, attrs: &1})
  end

  describe "list_users/0" do
    test "without users returns an empty list" do
      assert [] == Accounts.list_users()
    end

    test "with users returns all users" do
      user = insert(:user) |> Map.put(:password, nil)

      assert [user] == Accounts.list_users()
    end
  end

  describe "get_user/1 returns :ok" do
    setup [:insert_user]

    test "when the given id is found", %{user: user} do
      assert {:ok, %User{} = user} == Accounts.get_user(user.id)
    end

    test "when the given email is found", %{user: user} do
      assert {:ok, %User{} = user} == Accounts.get_user(email: user.email)
    end
  end

  describe "get_user/1 returns :error" do
    test "when the given id is not found" do
      id = Ecto.UUID.generate()

      assert {:error, changeset} = Accounts.get_user(id)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end

    test "when the given email is not found" do
      email = Faker.Internet.email()

      assert {:error, changeset} = Accounts.get_user(email: email)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "not found")
    end
  end

  describe "create_user/1 returns :ok" do
    test "when the user attributes are valid", %{attrs: attrs} do
      assert {:ok, %User{} = user} = Accounts.create_user(attrs)

      assert user.email == attrs.email
      assert user.name == attrs.name
      assert Argon2.verify_pass(attrs.password, user.password_hash)
    end
  end

  describe "create_user/1 returns :error" do
    test "when the user attributes are invalid" do
      attrs = %{email: "???", name: nil, password: "?"}

      assert {:error, changeset} = Accounts.create_user(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
      assert Enum.member?(errors.name, "can't be blank")
      assert Enum.member?(errors.password, "should be at least 6 character(s)")
    end

    test "when the user attributes are not given" do
      assert {:error, changeset} = Accounts.create_user()
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "can't be blank")
      assert Enum.member?(errors.name, "can't be blank")
      assert Enum.member?(errors.password, "can't be blank")
    end

    test "when the user email already exists", %{attrs: attrs} do
      attrs =
        insert(:user)
        |> then(&Map.put(attrs, :email, &1.email))

      assert {:error, changeset} = Accounts.create_user(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has already been taken")
    end
  end

  describe "update_user/2 returns :ok" do
    setup [:insert_user]

    test "when the user attributes are valid", %{user: user, attrs: attrs} do
      assert {:ok, %User{} = user} = Accounts.update_user(user, attrs)

      assert attrs.email == user.email
      assert attrs.name == user.name
      assert Argon2.verify_pass(attrs.password, user.password_hash)
    end
  end

  describe "update_user/2 returns :error" do
    setup [:insert_user]

    test "when the user attributes are invalid", %{user: user} do
      invalid_attrs = %{email: "?@?", name: "?", password: nil}

      assert {:error, changeset} = Accounts.update_user(user, invalid_attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
      assert Enum.member?(errors.name, "should be at least 2 character(s)")
      assert Enum.member?(errors.password, "can't be blank")
    end
  end

  describe "delete_user/1" do
    setup [:insert_user]

    test "deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)

      assert {:error, changeset} = Accounts.get_user(user.id)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end
  end

  describe "change_user/1" do
    setup [:insert_user]

    test "returns a changeset", %{user: user} do
      assert %Changeset{} = Accounts.change_user(user)
    end
  end

  defp insert_user(_) do
    :user
    |> insert()
    |> Map.put(:password, nil)
    |> then(&{:ok, user: &1})
  end
end
