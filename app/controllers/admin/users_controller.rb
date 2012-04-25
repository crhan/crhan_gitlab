class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!
  respond_to :html

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with @user, :location => [:admin, :users]
  end

  def new
    @admin_user = User.new
  end

  def create
    admin = params[:user].delete(:admin)
    @admin_user = User.new(params[:user])
    @admin_user.admin = admin
    @admin_user.save!
    respond_with @admin_user, :location => [:admin,:users]
  end

  def show
    @admin_user = User.find(params[:id])
  end
end
