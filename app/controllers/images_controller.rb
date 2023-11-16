class ImagesController < ApplicationController
  def create
    viewport_width = params.fetch(:viewport_width, 1280).to_i
    viewport_height = params.fetch(:viewport_height, 800).to_i
    device_scale_factor = params.fetch(:device_scale_factor, 2).to_i
    full_page = params.fetch(:full_page, false)
    html = params[:html]
    url = params[:url]
    type = params.fetch(:type, "png")

    if html.nil? && url.nil?
      render json: { error: "You must provide either `html` or `url` parameter" }, status: :bad_request
      return
    end

    if html.present? && url.present?
      render json: { error: "You must provide either `html` or `url` parameter, not both" }, status: :bad_request
      return
    end

    if !type.in?(%w(png jpeg webp))
      render json: { error: "Invalid `type` parameter" }, status: :bad_request
      return
    end

    Puppeteer.launch do |browser|
      page = browser.new_page

      page.viewport = Puppeteer::Viewport.new(width: viewport_width, height: viewport_height, device_scale_factor: device_scale_factor)

      if html
        page.set_content html
      elsif url
        page.goto url
      end

      image = page.screenshot full_page: full_page, type: type

      send_data image, type: "image/#{type}", disposition: "inline"
    end
  end
end
