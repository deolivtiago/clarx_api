defmodule ClarxApi.Factories.UserFactory do
  use ExMachina.Ecto, repo: ClarxApi.Repo

  alias ClarxApi.Accounts.User
  alias Faker

  def user_factory do
    password = Base.encode64(:crypto.strong_rand_bytes(32), padding: false)

    %User{
      id: Faker.UUID.v4(),
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password: password,
      password_hash: Argon2.hash_pwd_salt(password),
      inserted_at: Faker.DateTime.backward(366),
      updated_at: DateTime.utc_now()
    }
  end
end
