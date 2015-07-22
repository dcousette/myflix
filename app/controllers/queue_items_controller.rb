class QueueItemsController < ApplicationController 
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    @video = Video.find(params[:video_id])
    @queue_item = @video.queue_items.new 
    @queue_item.user = User.find(params[:user_id])
    @queue_item.position = current_user.queue_items.count + 1
    
    if @queue_item.save 
      redirect_to my_queue_path
    else 
      redirect_to video_path(@video)
    end
  end
  
  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user == queue_item.user 
    redirect_to my_queue_path
  end
end