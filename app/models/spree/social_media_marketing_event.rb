module Spree
  class SocialMediaMarketingEvent < ActiveRecord::Base
    validates :fb_message, :twitter_message, presence: true
    validate :can_be_activated, if: :active_and_active_changed?
    validate :message_without_methods_does_not_exceed_maxinmum_length
    validate :check_fb_message, if: :fb_message_changed?
    validate :check_twitter_message, if: :twitter_message_changed?

    has_many :social_media_events_accounts, class_name: 'Spree::SocialMediaEventsAccount'
    has_many :facebook_accounts, through: :social_media_events_accounts, source: :social_media_marketing_account, source_type: 'Spree::FacebookPage'
    has_many :twitter_accounts, through: :social_media_events_accounts, source: :social_media_marketing_account, source_type: 'Spree::SocialMediaAccount'

    accepts_nested_attributes_for :social_media_events_accounts, allow_destroy: true

    def get_parsed_message(instance, type='facebook', options = {})
      parse_string(get_instance_methods(type), instance, type, options)
    end

    def linked_social_media_accounts
      facebook_accounts + twitter_accounts
    end

    def all_social_media_accounts
      Spree::FacebookPage.all + Spree::TwitterAccount.all
    end

    def unlinked_social_media_accounts
      all_social_media_accounts - linked_social_media_accounts
    end

    private
      def parse_string(methods, instance, type='facebook', options = {})
        message = type.eql?('facebook') ? fb_message : twitter_message
        parsed_message = message.dup
        methods.each do |method|
          method_name = method[1, (method.length - 2)]
          parsed_message.gsub!(method, (options[method_name.to_sym] || instance.send(method_name)) || '')
        end
        parsed_message
      end

      def message_without_methods_does_not_exceed_maxinmum_length
        if twitter_message.gsub(/<.*?>/, '').length > Spree::TwitterAccount::MESSAGE_MAXIMUM_LENGTH
          errors.add(:twitter_message, "without dynamic content can not be more than #{ Spree::TwitterAccount::MESSAGE_MAXIMUM_LENGTH } characters long")
        end
      end

      def get_instance_methods(type='facebook')
        message = type.eql?('facebook') ? fb_message : twitter_message
        methods = message.scan(/(<.*?>)/).flatten.uniq
      end

      def check_fb_message
        message_is_parsable('facebook')
      end

      def check_twitter_message
        message_is_parsable('twitter')
      end

      def message_is_parsable(type)
        begin
          klass = eval(class_to_run)
          if klass.respond_to?(:get_social_marketing_message)
            get_parsed_message(klass, type)
          elsif klass.new.respond_to?(:get_social_marketing_message)
            get_parsed_message(klass.new, type)
          end
        rescue StandardError => e
          errors.add(:base, 'Some of the methods used in the message are not valid. Please check the methods list.')
        end
      end

      def can_be_activated
        if run_time == 'future' && Rails.application.config.active_job.queue_adapter == :inline
          errors.add(:base, 'To activate this event, you need a queueing backend adapter, which is not implemented for this app. Please contact your developer.')
        end
      end

      def active_and_active_changed?
        active_changed? and active?
      end
  end
end