class AddErrorMessageToSocialMediaPost < ActiveRecord::Migration
  def change
    add_column :spree_social_media_posts, :error_message, :text
  end
end
