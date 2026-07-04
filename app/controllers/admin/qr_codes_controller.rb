class Admin::QrCodesController < Admin::BaseController
  def show
    @url = root_url
    @qr_svg = RQRCode::QRCode.new(@url).as_svg(
      color: "3a4034",
      module_size: 10,
      use_path: true,
      viewbox: true
    )
  end
end
