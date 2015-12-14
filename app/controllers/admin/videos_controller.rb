class Admin::VideosController < ApplicationController
  before_action :require_login
  before_action :require_admin 

  def new
    @video = Video.new
  end

  def create
  end
end
