module Spree
  class SocialMediaAccount < ActiveRecord::Base
    belongs_to :store, class_name: 'Spree::Product'

    def self.types
      %w(Facebook Twitter)
    end

    def display_type
      type.match(/spree\:\:(.*)account/i)[1]
    end
  end
end