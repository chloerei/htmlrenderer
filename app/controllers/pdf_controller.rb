class PdfController < ApplicationController
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
          scale: {type: :number},
          display_header_footer: {type: :boolean},
          header_template: {type: :string},
          footer_template: {type: :string},
          print_background: {type: :boolean},
          landscape: {type: :boolean},
          page_ranges: {type: :string},
          format: {type: :string},
          width: {type: [:string, :number]},
          height: {type: [:string, :number]},
          prefer_css_page_size: {type: :boolean},
          margin: {
            type: :object,
            properties: {
              top: {type: [:string, :number]},
              bottom: {type: [:string, :number]},
              left: {type: [:string, :number]},
              right: {type: [:string, :number]}
            }
          }
        }
      },
      extra_http_headers: {
        type: :object
      }
    }
  }

  def create
    JSON::Validator.validate!(SCHEMA, pdf_params.to_h)

    Puppeteer.launch do |browser|
      page = browser.new_page

      if pdf_params[:extra_http_headers]
        page.extra_http_headers = pdf_params[:extra_http_headers]
      end

      if pdf_params[:html]
        page.set_content pdf_params[:html]
      elsif pdf_params[:url]
        page.goto pdf_params[:url]
      end

      pdf = page.pdf(**(pdf_params[:options].to_h || {}).to_options)

      content_type = Mime::Type.lookup_by_extension("pdf").to_s
      send_data pdf, type: content_type, disposition: "inline"
    end
  end

  private

  def pdf_params
    @pdf_params = params.require(:pdf).permit(
      :html,
      :url,
      options: [:scale, :display_header_footer, :header_template, :footer_template, :print_background, :landscape, :page_ranges, :format, :width, :height, :prefer_css_page_size, margin: [:top, :bottom, :left, :right]],
      extra_http_headers: {}
    )
  end
end
