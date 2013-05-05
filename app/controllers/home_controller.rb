class HomeController < ApplicationController
  def index
    #TODO: need to make this changable
    current_user.setGitHubUsername("henghonglee1")
  end
  
  def setGitHubName
    current_user.setGitHubUsername(params[:username])
    redirect_to root_path
  end
end
