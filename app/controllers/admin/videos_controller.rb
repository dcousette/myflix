class Admin::VideosController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)

    if @video.save
      flash[:success] = "Your video #{@video.title} has been added"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Please retry your entry"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover, :video_url)
  end
end
