class WebContent < ActiveRecord::Base
  validates :url, presence: true, allow_nil: false
  validates_format_of :url, with: /http[s]?:\/\/www/i
end
