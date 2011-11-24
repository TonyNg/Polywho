class Profile < ActiveRecord::Base
attr_accessible :major, :year, :books_sell, :books_buy, :facebook, :restaurants,
  :interests
  
    belongs_to :user
end
