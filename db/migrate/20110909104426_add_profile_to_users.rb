class AddProfileToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :major, :string
    add_column :users, :year, :string
    add_column :users, :books_sell, :string
    add_column :users, :books_buy, :string
    add_column :users, :facebook, :string
    add_column :users, :restaurants, :string
    add_column :users, :interests, :string
  end

  def self.down
    remove_column :users, :interests
    remove_column :users, :restaurants
    remove_column :users, :facebook
    remove_column :users, :books_buy
    remove_column :users, :books_sell
    remove_column :users, :year
    remove_column :users, :major
  end
end
