class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password_digest, :first_name, :last_name, presence: true
end
