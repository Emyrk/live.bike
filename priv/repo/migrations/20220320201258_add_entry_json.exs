defmodule Bike.Repo.Migrations.AddEntryJson do
  use Ecto.Migration

  def change do
    alter table("entries") do
      add(:json, :text)
    end
  end
end
