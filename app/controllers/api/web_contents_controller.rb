class Api::WebContentsController < ApplicationController

  before_action :set_variables, :verify_url, only: [:create]

  def index
    @web_contents = WebContent.all
  end

  def create
    index_url

    if @success
      render json: { message: "success" }, status: 200
    else
      render json: { message: @message }, status: 400
    end

  rescue => e
    Rails.logger.fatal("Crashed parsing url: #{@url}")
    Rails.logger.fatal(e)
    render json: { message: "Unknown error occurred. Unable to parse url." },
           status: 400
  end

  private

  def index_url
    @response = HTTParty.get(@url)

    handle_response

  rescue HTTParty::Error => e
    Rails.logger.error("HTTParty failed to fetch url #{@url}")
    Rails.logger.error(e)
    @success = false
    @message = "Unable to fetch url"

  rescue Errno::ECONNREFUSED => e
    @success = false
    @message = "Connection refused. Try a different url."
  end

  def handle_response
    case @response.code
      when 200
        parse_response
      when 404
        @success = false
        @message = "Missing page responded 404: No content found at that url."
      when 500...600
        @success = false
        @message = "Url responding with server error."
    end
  end

  def parse_response
    page = Nokogiri::HTML(@response.body)

    parse_header_groups(page)
    parse_links(page)

    encode_content

    save_content

  rescue => e
    Rails.logger.error("Failed to parse content at url: #{@url}")
    Rails.logger.error(e)
    @success = false
    @message = "Unable to parse content at that url."
  end

  def save_content
    WebContent.new(url: @url, content: @content).save
  end

  def encode_content
    @content = @content.encode('UTF-8', invalid: :replace, undef: :replace,
                                        replace: ' ')
  end

  def parse_header_groups(page)
    header_groups = [page.css('h1'), page.css('h2'), page.css('h3')]

    header_groups.each do |headers|
      parse_headers(headers)
    end
  end

  def parse_links(page)
    link_tags = page.css('a')

    link_tags.each do |link|
      @content += tag_content(link)
      @content += link_href(link)
    end
  end

  def parse_headers(headers)
    headers.each do |tag|
      @content += tag_content(tag)
    end
  end

  def tag_content(tag)
    if tag and tag.text
      tag.text + " "
    else
      ''
    end
  end

  def link_href(link)
    if link && link['href']
      link['href'] + " "
    else
      ''
    end
  end

  def verify_url
    unless /\Ahttp[s]?:\/\// =~ @url
      render json: { message: "Bad protocol. Url must start with valid protocol like 'https://'" }, status: 400
      return
    end
  end

  def set_variables
    @success = true
    @content = ""
    @url = params[:url] || ""
  end
end
