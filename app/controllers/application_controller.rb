class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :project_clone_path

  def authenticate_admin!
    return render_404 unless current_user.is_admin?
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => 404 }
      format.any {head :not_found}
    end
  end

  def project_clone_path project
    "git@#{GIT_HOST["host"]}:#{project.path}.git"
  end
end
