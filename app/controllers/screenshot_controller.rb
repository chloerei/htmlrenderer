class ScreenshotController < ApplicationController
  SCHEMA = {
    type: :object,
    oneOf: [
      {required: [:html]},
      {required: [:url]}
    ],
    properties: {
      html: {type: :string},
      url: {type: :string},
      options: {
        type: :object,
        properties: {
          capture_beyond_viewport: {type: :boolean},
          clip: {
            type: :object,
            properties: {
              x: {type: :number},
              y: {type: :number},
              width: {type: :number},
              height: {type: :number},
              scale: {type: :number}
            }
          },
          encoding: {type: :string},
          full_page: {type: :boolean},
          omit_background: {type: :boolean},
          quality: {type: :number},
          type: {type: :enum, enum: ["jpeg", "png", "webp"]}
        }
      },
      viewport: {
        type: :object,
        properties: {
          width: {type: :number},
          height: {type: :number},
          device_scale_factor: {type: :number},
          is_mobile: {type: :boolean},
          has_touch: {type: :boolean},
          is_landscape: {type: :boolean},
          additionalProperties: false
        }
      },
      extra_http_headers: {
        type: :object
      }
    }
  }

  def create
    JSON::Validator.validate!(SCHEMA, screenshot_params)

    Puppeteer.launch do |browser|
      page = browser.new_page

      if screenshot_params[:viewport]
        page.viewport = Puppeteer::Viewport.new(**screenshot_params[:viewport].to_options)
      end

      if screenshot_params[:extra_http_headers]
        page.extra_http_headers = screenshot_params[:extra_http_headers]
      end

      if screenshot_params[:html]
        page.set_content screenshot_params[:html]
      elsif screenshot_params[:url]
        page.goto screenshot_params[:url]
      end

      image = page.screenshot(**(screenshot_params[:options] || {}).to_options)

      content_type = Mime::Type.lookup_by_extension(screenshot_params.dig(:options, :type) || "png").to_s
      send_data image, type: content_type, disposition: "inline"
    end
  end

  private

  def screenshot_params
    @screenshot_params ||= params.require(:screenshot).permit(
      :html,
      :url,
      options: [:capture_beyond_viewport, :encoding, :full_page, :omit_background, :quality, :type, clip: [:x, :y, :width, :height, :scale]],
      viewport: [:width, :height, :device_scale_factor, :is_mobile, :has_touch, :is_landscape],
      extra_http_headers: {}
    ).to_h
  end
end
