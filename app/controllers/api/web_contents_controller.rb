class Api::WebContentsController < ApplicationController
  require 'open-uri'
  require 'net/http'

  before_action :set_variables, :verify_url, only: [:create]

  ERROR_MESSAGE = "Couldn't fetch or parse web page.".freeze

  def index
    @web_contents = WebContent.all
  end

  def create
    @response = Net::HTTP.get_response(URI(@url))

    if successful_response?
      render json: { message: "success" }, status: 200
    else
      error_response
    end

  rescue
    error_response
  end

  private

  def error_response
    render json: { message: "Couldn't fetch or parse web page." }, status: 400
  end

  def save_content
    WebContent.new(url: @url, content: encoded_content).save
  end

  def encoded_content
    @content.force_encoding('UTF-8').encode('UTF-8', invalid: :replace,
                                                     undef: :replace,
                                                     replace: ' ')
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
    @response.is_a?(Net::HTTPSuccess) && parse_response && save_content
  end

  def verify_url
    unless /http[s]?:\/\/www/ =~ @url
      render json: { message: "Bad format. Url must start with valid protocol like 'https://www'. Try again" }, status: 400
      return
    end
  end

  def set_variables
    @content = ""
    @url = params[:url] || ""
  end
end
