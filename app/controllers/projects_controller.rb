class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_id, :only => [:show, :destroy, :edit, :update]
  before_filter :check_key, :only => [:new]
  respond_to :html, :xml, :json

  def index
    @projects = Project.order("updated_at DESC")
    @last_5_activities = Event.limit(5)
    respond_with(@projects)
  end

  def new
    @project = Project.new
  end

  def create
    owner_id = params[:project].delete(:owner)
    @project = Project.new(params[:project])
    @project.owner = User.find(owner_id)
    @project.current_user_id = current_user.id

    @project.save
    # create owner as the master
    @project.set_owner_as_master

    if @project.valid?
      redirect_to @project, :notice => "Project created successfully"
    else
      render :action => :new
    end
  end

  def show
    @events = @project.events.limit(5)
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  def edit
  end

  def update
    owner_id = params[:project].delete(:owner)
    @project.description = params[:project][:description]
    @project.owner = User.find(owner_id)
    @project.current_user_id = current_user.id
    @project.save

    respond_with(@project)
  end

  private
  def find_id
    @project = Project.find(params[:id])
    @current_user = current_user
  end

  def check_key
    unless current_user.keys.size >0
      redirect_to [:keys], :alert => "You must has a key first"
    end
  end
end
