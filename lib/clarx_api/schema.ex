defmodule ClarxApi.Schema do
  @moduledoc """
  Define a module to be used as base schema.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime]

      @doc """
      Creates a changeset with errors.
      ## Examples
          iex> invalid_changeset(:id, 123, "invalid uuid", [validation: :format])
          %Ecto.Changeset{
              action: nil,
              changes: %{id: 123},
              errors: [id: {"invalid uuid", [validation: :format]}],
              data: #Module.Schema<>,
              valid?: false
          }
      """
      def invalid_changeset(field, value, message, additional_info \\ []) do
        struct(__MODULE__)
        |> Ecto.Changeset.change(%{field => value})
        |> Ecto.Changeset.add_error(field, message, additional_info)
      end
    end
  end
end
