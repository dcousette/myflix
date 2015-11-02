class User < ActiveRecord::Base
  validates_presence_of :email_address, :password, :full_name
  validates_uniqueness_of :email_address
  has_secure_password validations: false
  has_many :queue_items, -> { order('position ASC') } 
  has_many :reviews , -> { order('created_at DESC') } 
  has_many :following_friendships, class_name: 'Friendship', foreign_key: :follower_id
  
  before_create :generate_token 
  
  def normalize_queue_item_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end
  
  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
  
  def number_of_reviews
    reviews.count 
  end
  
  def queue_item_count 
    queue_items.count 
  end
  
  def follows?(user)
    following_friendships.map(&:leader_id).include?(user.id)
  end
  
  def generate_token 
    self.token = SecureRandom.urlsafe_base64
  end
end