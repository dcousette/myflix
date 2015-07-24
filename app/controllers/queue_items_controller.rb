class QueueItemsController < ApplicationController 
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    video = Video.find(params[:video_id])
    queue_item_create(video)                 
    redirect_to my_queue_path
  end
  
  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user == queue_item.user 
    redirect_to my_queue_path
  end
  
  private 
  
    def queue_item_count
      current_user.queue_items.count + 1
    end
    
    def contains_current_queue_item?(video)
      current_user.queue_items.map(&:video).include?(video)
    end
    
    def queue_item_create(video)
      QueueItem.create(video: video, user: current_user, 
                       position: queue_item_count) unless contains_current_queue_item?(video)
    end
end