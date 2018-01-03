class WebContent < ActiveRecord::Base
  validates :content, presence: true, allow_nil: false

  validates :url, format: URI::regexp(%w(http https))
end
