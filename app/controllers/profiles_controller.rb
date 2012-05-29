class ProfilesController < ApplicationController
  before_filter :find_profile
  before_filter :authenticate_user!
  respond_to :html

  def show
  end

  def destroy
    @profile.destory
    respond_with(@profile)
  end

  private
  def find_profile
    @profile = current_user
  end
end
