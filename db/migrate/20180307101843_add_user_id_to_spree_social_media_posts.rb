class AddUserIdToSpreeSocialMediaPosts < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_social_media_posts, :user, index: true
  end
end
