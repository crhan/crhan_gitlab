class Admin::ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!
  respond_to :html
  before_filter :find_id, :except => [:new, :index, :create]

  def index
    @admin_projects = Project.all
  end

  def show
  end

  def edit
  end

  def new
    @admin_project = Project.new
  end

  def create
    @admin_project = Project.new(params[:project])
    @admin_project.owner = current_user
    @admin_project.save
    respond_with @admin_project
  end

  def destroy
    @admin_project.destroy
    respond_with @admin_project, :location => [:admin, :projects]
  end

  def update
    owner_id = params[:project][ :owner ]

    @admin_project.owner = User.find(owner_id) if owner_id
    @admin_project.description = params[:project][:description]
    @admin_project.save

    respond_with @admin_project, :location => [:admin, :projects]
  end

  private
  def find_id
    @admin_project = Project.find(params[:id])
  end
end
