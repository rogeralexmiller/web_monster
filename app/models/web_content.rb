class WebContent < ActiveRecord::Base
  validates :url, presence: true, allow_nil: false
  validates_format_of :url, with: /\Ahttp[s]?:\/\//i,
                      message: "Bad protocol. Url must start with valid protocol
                                like 'https://'"
end
