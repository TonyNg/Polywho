class AddCheckboxToUsers < ActiveRecord::Migration
  def self.up
      add_column :users, :check, :string
  end

  def self.down
      remove_column :users, :check
  end
end
