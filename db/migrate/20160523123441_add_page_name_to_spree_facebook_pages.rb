class AddPageNameToSpreeFacebookPages < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_facebook_pages, :page_name, :string
  end
end
