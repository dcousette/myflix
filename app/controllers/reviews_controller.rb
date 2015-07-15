class ReviewsController < ApplicationController
  before_action :require_login, only: :create 
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    
    if @review.save
      flash[:notice] = 'Review saved'
      redirect_to videos_path
    else
      redirect_to home_path
    end
  end
  
  private 
  
  def review_params
    params.require(:review).permit(:user_id, :video_id, :rating, :content)
  end
end