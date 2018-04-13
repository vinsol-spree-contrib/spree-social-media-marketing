Koala::Facebook::OAuth.class_eval do

  module DefaultSettings
    def initialize(*args)
      case args.size
        when 0, 1
          app_key = Rails.application.secrets.facebook_app_key
          app_secret = Rails.application.secrets.facebook_app_secret
          raise "application id and/or secret are not specified in the Rails secrets" unless app_key && app_secret
          super(app_key.to_s, app_secret.to_s, args.first)
        when 2, 3
          super(*args)
      end
    end
  end

  prepend DefaultSettings
end
