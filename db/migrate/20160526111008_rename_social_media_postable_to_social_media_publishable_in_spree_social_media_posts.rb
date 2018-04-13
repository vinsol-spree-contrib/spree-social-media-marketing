class RenameSocialMediaPostableToSocialMediaPublishableInSpreeSocialMediaPosts < ActiveRecord::Migration[4.2]
  def change
    rename_column :spree_social_media_posts, :social_media_postable_id, :social_media_publishable_id
    rename_column :spree_social_media_posts, :social_media_postable_type, :social_media_publishable_type
  end
end
