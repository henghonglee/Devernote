class HomeController < ApplicationController
  def index
    #TODO: need to make this changable
    if current_user
      current_user.setGitHubUsername("henghonglee1")
    end
  end
  
  def setGitHubName
      current_user.setGitHubUsername("")

    redirect_to root_path
  end
end
