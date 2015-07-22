class User < ActiveRecord::Base
  validates_presence_of :email_address, :password, :full_name
  validates_uniqueness_of :email_address
  has_secure_password validations: false
  has_many :queue_items
end