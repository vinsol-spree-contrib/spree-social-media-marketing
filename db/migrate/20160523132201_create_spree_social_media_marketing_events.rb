class CreateSpreeSocialMediaMarketingEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_social_media_marketing_events do |t|
      t.string :name
      t.boolean :enabled, default: false
      t.text :message
    end
  end
end
