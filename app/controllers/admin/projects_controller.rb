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
    @admin_project.save!
    respond_with @admin_project
  end

  def destroy
    @admin_project.destroy
    respond_with @admin_project, :location => [:admin, :projects]
  end

  def update
    ownder_id = params[:project].delete(:owner_id)

    @admin_project.owner = User.find(owner_id) if owner_id

    @admin_project.update_attributes!(params[:project])
    respond_with @admin_project
  end

  private
  def find_id
    @admin_project = Project.find(params[:id])
  end
end
