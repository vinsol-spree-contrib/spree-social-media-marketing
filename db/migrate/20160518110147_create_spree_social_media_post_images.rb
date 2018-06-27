class CreateSpreeSocialMediaPostImages < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_social_media_post_images do |t|
      t.references :social_media_post
      t.references :image
    end
  end
end
