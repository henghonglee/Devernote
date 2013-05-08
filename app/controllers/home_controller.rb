class HomeController < ApplicationController
  caches_page :index
  def index
    
  end
  def removetag
    current_user.tags.delete(params[:tagname])
    current_user.save
    redirect_to root_path
  end
  def addtag
    for tag in current_user.tags
      if tag == params[:tagname]
        return
      end
    end
    current_user.tags << params[:tagname]
    current_user.save
    redirect_to root_path
  end
end