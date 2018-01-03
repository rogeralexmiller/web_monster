class Api::WebContentsController < ApplicationController
  require 'open-uri'

  def index
  end

  def create
    raw_url = params[:url]
    uri = URI(raw_url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      page = Nokogiri::HTML(response.body)
      content = ''
      tag_collections = [ page.css('h1'), page.css('h2'), page.css('h3'),
                          page.css('a') ]

      tag_collections.each do |collection|
        collection.each do |tag|
          content += tag.text
        end
      end
      render json: { content: content.force_encoding("ISO-8859-1").encode('utf-8') }, status: 200
    else
      render json: { content: "bad url" }, status: 400
    end
  end
end
