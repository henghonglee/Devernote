class RepoController < ApplicationController
  def index
    
      
  end
  
  def show
    Resque.enqueue(GitWorker,params[:user_id],params[:id])
    redirect_to root_path
  end
  
  def edit
  end

  def create
  end

  def new
  end

  def destroy
  end

  def update
  end
end
