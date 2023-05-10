defmodule ClarxApi.Accounts.User do
  @moduledoc """
  The user schema.
  """
  use ClarxApi.Schema

  import Ecto.Changeset

  alias Argon2

  @required_attrs [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:id, name: :users_pkey)
    |> validate_length(:name, min: 2, max: 128)
    |> unique_constraint(:email)
    |> validate_length(:email, min: 3, max: 128)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/^[a-z0-9\-._+&#$?!]+[@][a-z0-9\-._+]+$/)
    |> validate_length(:password, min: 6, max: 128)
    |> put_pass_hash()
  end

  defp put_pass_hash(%{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
