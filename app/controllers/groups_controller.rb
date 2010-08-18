class GroupsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @posts = current_user.posts.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def create
    @group = current_user.group(params[:group])
    
    if @group.created_at
      flash[:notice] = "Successfully created group."
      redirect_to @group
    else
      render :action => 'new'
    end
  end
  
  def new
    @group = Group.new
  end
  
  def destroy
    @group = Group.first(:id => params[:id])
    @group.destroy
    flash[:notice] = "Successfully destroyed group."
    redirect_to groups_url
  end
  
  def show
    @people_ids = @group.person_ids

    @group = Group.first(:id => params[:id])

    @posts = current_user.posts_for( :group => @group ).paginate :order => 'created_at DESC'
    #@posts = Post.paginate :person_id => @people_ids, :order => 'created_at DESC'
  end

  def edit
    @group = Group.first(:id => params[:id])
  end

  def update
    @group = Group.first(:id => params[:id])
    if @group.update_attributes(params[:group])
      flash[:notice] = "Successfully updated group."
      redirect_to @group
    else
      render :action => 'edit'
    end
  end

end