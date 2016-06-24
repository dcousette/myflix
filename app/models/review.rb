class Review < ActiveRecord::Base
  belongs_to :video, touch: true
  belongs_to :user
  validates_presence_of :rating, :content

  def video_title
    video.title
  end
end
