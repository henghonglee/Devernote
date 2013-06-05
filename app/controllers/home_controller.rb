class HomeController < ApplicationController
  caches_page :index
  def index
    if current_user
     if current_user.github_username
      redirect_to devernote_index_path
     end
    end
  end
  def removetag
    current_user.tags.delete(params[:tagname])
    current_user.save
    redirect_to devernote_index_path
  end
  def addtag
    for tag in current_user.tags
      if tag == params[:tagname]
        return
      end
    end
    current_user.tags << params[:tagname]
    current_user.save
    redirect_to devernote_index_path
  end
end