class Admin::PhotosController < Admin::BaseController
  PER_PAGE = 60

  def index
    @total = Photo.count
    @page = [ params[:page].to_i, 1 ].max
    @pages = [ (@total / PER_PAGE.to_f).ceil, 1 ].max
    @photos = Photo.recent_first.with_attached_image
                   .offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def destroy
    Photo.find(params[:id]).destroy
    redirect_back fallback_location: admin_root_path, notice: "Fotografia eliminada."
  end
end
