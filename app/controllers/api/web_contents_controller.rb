class Api::WebContentsController < ApplicationController
  require 'open-uri'
  require 'net/http'
  # encoding: utf-8
  before_action :verify_url, :set_content, only: [:create]

  def index
    @web_contents = WebContent.all
  end

  def create
    raw_url = params[:url]
    uri = URI(raw_url)
    @response = Net::HTTP.get_response(uri)

    handle_response
  end

  private

  def set_content
    @content = ""
  end

  def handle_response
    if successful_response?
      parse_response
      save_content

      render json: { message: "success" }, status: 200
    else
      render json: { message: "Couldn't fetch web page." }, status: 400
    end

  rescue
    render json: { content: @content, message: "Couldn't parse web page." }, status: 500
  end

  def save_content
    WebContent.create(url: params[:url], content: @content.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: ''))
  end

  def parse_response
    tag_collections.each do |collection|
      parse_elements(collection)
    end
  end

  def parse_elements(elements)
    elements.each do |tag|
      @content += tag.text + " "
    end
  end

  def tag_collections
    page = Nokogiri::HTML(@response.body)

    [page.css('h1'), page.css('h2'), page.css('h3'), page.css('a')]
  end

  def successful_response?
    @response.is_a?(Net::HTTPSuccess)
  end

  def verify_url
    unless params[:url].starts_with?('https://www') || params[:url].starts_with?('http://www')
      render json: { message: "Bad format. Url must start with valid protocol like 'https://www'. Try again"}, status: 400
      return
    end
  end
end
