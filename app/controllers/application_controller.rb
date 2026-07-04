class ApplicationController < ActionController::Base
  # Nota: não usamos `allow_browser versions: :modern` para não bloquear
  # convidados com telemóveis mais antigos no dia do casamento.

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_admin

  private

  def current_admin
    return nil unless session[:admin_id]

    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end
end
