class CreateSocialMediaEventAccounts < ActiveRecord::Migration
  def change
    create_table :spree_social_media_events_accounts do |t|
      t.integer :social_media_marketing_event_id
      t.integer :social_media_marketing_account_id
      t.string :social_media_marketing_account_type

      t.timestamps
    end
  end
end
