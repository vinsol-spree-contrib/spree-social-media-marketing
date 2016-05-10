module Spree
  class FacebookPage < ActiveRecord::Base

    belongs_to :account, class_name: 'Spree::FacebookAccount', foreign_key: :account_id

    validates :page_id, uniqueness: {message: 'has already been added'}
    before_validation :get_and_assing_page_access_token

    def get_and_assing_page_access_token
      page_access_token_uri = URI("https://graph.facebook.com/#{ page_id }")
      page_access_token_uri.query = URI.encode_www_form(access_token: account.auth_token, fields: 'access_token')
      response = Net::HTTP.get_response(page_access_token_uri)
      response_json = JSON.parse(response.body)
      if response.code == '200'
        self.page_token = response_json['access_token']
      else
        errors.add(:base, response_json['error']['message'])
      end
    end

    def post_message(message)
      posting_message_uri = URI("https://graph.facebook.com/#{ page_id }/feed")
      posting_message_uri_query = { access_token: self.page_token, message: message }
      response = Net::HTTP.post_form(posting_message_uri, posting_message_uri_query)
      response_json = JSON.parse(response.body)
    end

    def post_image(url = '', caption = '')
      posting_image_uri = URI("https://graph.facebook.com/#{ page_id }/photos")
      posting_image_uri_query = { access_token: self.page_token, caption: caption, url: url }
      response = Net::HTTP.post_form(posting_image_uri, posting_image_uri_query)
      response_json = JSON.parse(response.body)
    end
  end
end