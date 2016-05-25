module Spree
  module SocialMediaUrlHelpers
    extend ActiveSupport::Concern

    def home_page
      Spree::Core::Engine.routes.url_helpers.root_url(host: (Rails.application.config.action_mailer.default_url_options.try(:[], :host) || 'localhost:3000'))
    end

    def product_url(product_id)
      Spree::Core::Engine.routes.url_helpers.product_url(product_id, host: (Rails.application.config.action_mailer.default_url_options.try(:[], :host) || 'localhost:3000'))
    end
  end
end
