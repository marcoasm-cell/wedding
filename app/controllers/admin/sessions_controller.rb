class Admin::SessionsController < ApplicationController
  def new
    redirect_to admin_root_path if current_admin
  end

  def create
    admin = Admin.find_by(email: params[:email].to_s.strip.downcase)

    if admin&.authenticate(params[:password].to_s)
      reset_session
      session[:admin_id] = admin.id
      redirect_to admin_root_path, notice: "Sessão iniciada. Bem-vindo!"
    else
      flash.now[:alert] = "Email ou palavra-passe inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to admin_login_path, notice: "Sessão terminada."
  end
end
