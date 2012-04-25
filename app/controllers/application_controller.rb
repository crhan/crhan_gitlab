class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_admin!
    return render_404 unless current_user.is_admin?
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => 404 }
      format.any {head :not_found}
    end
  end
end
