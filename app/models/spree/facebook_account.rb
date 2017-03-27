module Spree
  class FacebookAccount < SocialMediaAccount

    has_many :pages, class_name: 'Spree::FacebookPage', foreign_key: :account_id, dependent: :destroy

    def post(message, images)
      self.pages.each do |facebook_page|
        facebook_page.post(message, images)
      end
    end

    def display_account_name
      'Facebook'
    end
  end
end
