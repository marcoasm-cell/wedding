class UploadsController < ApplicationController
  def new
  end

  def create
    images = Array(params[:images]).reject(&:blank?)

    if images.empty?
      flash.now[:alert] = "Selecione pelo menos uma fotografia."
      return render :new, status: :unprocessable_entity
    end

    guest_name = params[:guest_name].to_s.strip.presence
    saved = 0

    images.each do |file|
      photo = Photo.new(guest_name: guest_name)
      photo.image.attach(file)
      saved += 1 if photo.save
    end

    if saved.positive?
      redirect_to thanks_path(count: saved)
    else
      flash.now[:alert] = "Não foi possível enviar as fotografias. Confirme que são imagens até 50 MB."
      render :new, status: :unprocessable_entity
    end
  end

  def thanks
    @count = params[:count].to_i
  end
end
