class ImagesController < ApplicationController
  def create
    param! :viewport_width, Integer, default: 1280
    param! :viewport_height, Integer, default: 800
    param! :device_scale_factor, Integer, default: 2
    param! :html, String
    param! :url, String
    param! :full_page, :boolean, default: false
    param! :type, String, default: "png", in: %w(png jpeg webp)

    if (params[:html].blank? && params[:url].blank?) || (params[:html].present? && params[:url].present?)
      raise RailsParam::InvalidParameterError, "Either `html` or `url` must be provided"
    end

    Puppeteer.launch do |browser|
      page = browser.new_page

      page.viewport = Puppeteer::Viewport.new(width: params[:viewport_width], height: params[:viewport_height], device_scale_factor: params[:device_scale_factor])

      if params[:html]
        page.set_content params[:html]
      elsif params[:url]
        page.goto params[:url]
      end

      image = page.screenshot full_page: params[:full_page], type: params[:type]

      send_data image, type: Mime::Type.lookup_by_extension(params[:type]).to_s, disposition: "inline"
    end

  rescue RailsParam::InvalidParameterError => e
    render json: { error: e.message }, status: :bad_request
  end
end
