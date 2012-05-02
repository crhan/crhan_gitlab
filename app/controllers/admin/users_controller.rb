class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!
  before_filter :find_id, :only => [:destroy, :edit, :update]
  respond_to :html

  def index
    @users = User.all
  end

  def destroy
    @admin_user.destroy
    respond_with @admin_user, :location => [:admin, :users]
  end

  def new
    @admin_user = User.new
  end

  def create
    admin = params[:user].delete(:admin)
    @admin_user = User.new(params[:user])
    @admin_user.admin = admin
    @admin_user.save
    respond_with @admin_user, :location => [:admin,:users]
  end

  def edit
  end

  # only update admin and password are allowd
  def update
    pw = params[:user][:password]
    @admin_user.password = pw unless pw.blank?
    @admin_user.admin = params[:user][:admin]
    @admin_user.save

    respond_with @admin_user, :location => [:admin,:users]
  end

  private
  def find_id
    @admin_user = User.find(params[:id])
  end

end
