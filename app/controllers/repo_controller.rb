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
    # TODO: render something useful here
    Resque.enqueue(GitWorker,params[:user_id],params[:repo_id])
    render :text => "sent worker to queue"
  end

  def new
  end

  def destroy
  end

  def update
  end
end
