class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_id, :only => [:show, :destroy]
  before_filter :check_key, :only => [:new]
  respond_to :html, :xml, :json

  def index
    @projects = current_user.projects
    respond_with(@projects)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.owner = current_user

    Project.transaction do
      @project.save!
      @project.user_projects.create!(:project_access => UserProject::MASTER,
                                     :user => current_user)
      @project.update_repository
    end

    if @project.valid?
      redirect_to @project, :notice => "Project created successfully"
    else
      render :action => :new
    end
  end

  def show
    respond_with(@project)
  end

  def destroy
    Project.transaction do
      @project.del_repo
      @project.destroy
    end
    respond_with(@project)
  end

  def index_team
    @project = Project.find(params[:project_id])
    @team_relation = @project.user_projects
    respond_with(@team_members)
  end

  private
  def find_id
    @project = Project.find(params[:id])
  end

  def check_key
    unless current_user.keys.size >0
      redirect_to [:keys], :alert => "You must has a key first"
    end
  end
end
