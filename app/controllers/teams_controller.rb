class TeamsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @project = Project.find(params[:project_id])
    @team_relation = @project.user_projects
    respond_with(@team_members)
  end

  def new
    @project = Project.find(params[:project_id])
    @team = @project.user_projects.new
  end

  def create
    @project = Project.find(params[:project_id])
    UserProject.transaction do
      @member = UserProject.new(params[:member])
      @member.project = @project
      @member.save!
    respond_with(@member, :location => project_teams_path)
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @member = @project.user_projects.find(params[:id])
    UserProject.transaction do
      @member.destroy
      CrhanGit::CrhanGit.new.update_repo(@project)
    end
    respond_with(@member, :location => project_teams_path)
  end

  def edit
    @project = Project.find(params[:project_id])
    @member = UserProject.find(params[:id])
    @team_member = @member.user
  end

  def update
    @project = current_user.projects.find(params[:project_id])
    @member = UserProject.find(params[:id])
    @member.update_attributes(params[:member])
    respond_with(@member, :location => project_teams_path)
  end

end
