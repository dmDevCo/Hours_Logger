class User < ActiveRecord::Base

has_secure_password
has_many :time_cards
validates :name, :presence => true, :uniqueness => true 
validates :email, :presence => true, :uniqueness => true 

end
