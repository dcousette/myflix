class AdminsController < ApplicationController
  before_action :require_admin
  
  private

  def require_admin
    if !current_user.admin?
      flash[:danger] = "Access denied!"
      redirect_to home_path
    end
  end
end
