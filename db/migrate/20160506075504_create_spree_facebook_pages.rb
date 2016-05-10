class CreateSpreeFacebookPages < ActiveRecord::Migration
  def change
    create_table :spree_facebook_pages do |t|
      t.references :account
      t.string :name
      t.string :page_id
      t.string :page_token

      t.timestamps
    end
  end
end
