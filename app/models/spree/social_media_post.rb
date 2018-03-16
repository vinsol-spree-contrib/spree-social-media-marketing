module Spree
  class SocialMediaPost < Spree::Base

    attr_accessor :fb_message, :twitter_message, :fb_accounts, :twitter_accounts

    ## TODO: Can we rename this to social_media_publishable? postable is no word.
    belongs_to :social_media_publishable, polymorphic: true
    belongs_to :user, class_name: 'Spree::User'
    has_many :social_media_post_images, dependent: :destroy
    has_many :images, through: :social_media_post_images, source: :post_image

    ## TODO: Why is this limit present? Should be only for Twitter. Also, extract to a constant.(done)
    ## TODO: Add validations for presence of social_media_publishable
    validates :post_message, presence: true
    validates :post_message, length: { maximum: Spree::TwitterAccount::MAXIMUM_TWEET_LENGTH }, if: :social_media_publishable_is_twitter_account?
    validates :social_media_publishable, presence: true
    accepts_nested_attributes_for :images

    after_create :send_post_and_assign_post_id
    after_destroy :destroy_post_on_social_media, unless: :destroyed_by_association

    def send_post_and_assign_post_id
      begin
        post_id = social_media_publishable.post(post_message, images)
        self.update(post_id: post_id, error_message: nil)
      rescue StandardError => e
        self.update(error_message: e.message)
      end
    end

    def truncate_message(message)
      message.truncate(Spree::TwitterAccount::MAXIMUM_TWEET_LENGTH)
    end

    def create_fb_twitter_posts
      fb_posts = build_posts('facebook')
      twitter_posts = build_posts('twitter')
      save_posts!(fb_posts + twitter_posts)
    end

    def build_posts(social_media)
      posts = []
      get_accounts(social_media).try(:each) do |account_id|
        post = dup
        post.images = images
        post.social_media_publishable = fetch_account(social_media, account_id)
        post.post_message = post.send(:get_message, social_media)
        posts << post
      end
      posts
    end

    def save_posts!(posts)
      Spree::SocialMediaPost.transaction do
        posts.each do |post|
          begin
            post.save!
          rescue ActiveRecord::RecordInvalid => invalid
            return invalid.record.errors
          end
        end
      end
      false
    end

    private

      def fetch_account(social_media, id)
        social_media.eql?('facebook') ? Spree::FacebookPage.find(id) : Spree::TwitterAccount.find(id)
      end

      def get_message(social_media)
        social_media.eql?('facebook') ? fb_message : truncate_message(twitter_message)
      end

      def get_accounts(social_media)
        social_media.eql?('facebook') ? fb_accounts : twitter_accounts
      end

      def destroy_post_on_social_media
        social_media_publishable.remove_post(post_id) if post_id?
      end

      def social_media_publishable_is_twitter_account?
        social_media_publishable.class == Spree::TwitterAccount
      end
  end
end
