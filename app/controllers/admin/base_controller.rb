class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    redirect_to admin_login_path, alert: "Inicie sessão para aceder à área de administração." unless current_admin
  end
end
