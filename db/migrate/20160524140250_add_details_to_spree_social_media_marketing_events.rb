class AddDetailsToSpreeSocialMediaMarketingEvents < ActiveRecord::Migration
  def change
    add_column :spree_social_media_marketing_events, :class_to_run, :string
    add_column :spree_social_media_marketing_events, :run_time, :string
  end
end
