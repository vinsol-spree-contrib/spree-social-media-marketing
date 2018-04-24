class RenameColumnImagePostImage < ActiveRecord::Migration
  def change
    rename_column :spree_social_media_post_images, :image_id, :post_image_id
  end
end
