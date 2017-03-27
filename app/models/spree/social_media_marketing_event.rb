module Spree
  class SocialMediaMarketingEvent < ActiveRecord::Base
    validates :message, presence: true
    validate :message_is_parsable, if: :message_changed?
    validate :can_be_activated, if: :active_and_active_changed?
    validate :message_without_methods_does_not_exceed_maxinmum_length

    Spree::SocialMediaMarketingEvent::MessageMaximumLength = 120

    def get_parsed_message(instance, options = {})
      parse_string(get_instance_methods, instance, options)
    end

    private
      def parse_string(methods, instance, options = {})
        parsed_message = message.dup
        methods.each do |method|
          method_name = method[1, (method.length - 2)]
          parsed_message.gsub!(method, (options[method_name.to_sym] || instance.send(method_name)) || '')
        end
        parsed_message
      end

      def message_without_methods_does_not_exceed_maxinmum_length
        if message.gsub(/<.*?>/, '').length > 120
          errors.add(:message, 'without dynamic content can not be more than 120 charachters long')
        end
      end

      def get_instance_methods
        methods = message.scan(/(<.*?>)/).flatten.uniq
      end

      def message_is_parsable
        begin
          klass = eval(class_to_run)
          if klass.respond_to?(:get_social_marketing_message)
            get_parsed_message(klass)
          elsif klass.new.respond_to?(:get_social_marketing_message)
            get_parsed_message(klass.new)
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