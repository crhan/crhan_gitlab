class ProfilesController < ApplicationController
  before_filter :find_profile
  before_filter :authenticate_user!

  def show

  end

  private
  def find_profile
    @profile = current_user
  end
end
