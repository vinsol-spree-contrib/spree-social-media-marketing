Koala::Facebook::OAuth.class_eval do
  def initialize_with_default_settings(*args)
    case args.size
      when 0, 1
        app_key = Rails.application.secrets.facebook_app_key
        app_secret = Rails.application.secrets.facebook_app_secret
        raise "application id and/or secret are not specified in the Rails secrets" unless app_key && app_secret
        initialize_without_default_settings(app_key.to_s, app_secret.to_s, args.first)
      when 2, 3
        initialize_without_default_settings(*args)
    end
  end

  alias_method_chain :initialize, :default_settings
end
