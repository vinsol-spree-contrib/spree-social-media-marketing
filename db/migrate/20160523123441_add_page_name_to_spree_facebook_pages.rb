class AddPageNameToSpreeFacebookPages < ActiveRecord::Migration
  def change
    add_column :spree_facebook_pages, :page_name, :string
  end
end
