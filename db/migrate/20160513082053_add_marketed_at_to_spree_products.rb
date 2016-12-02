class AddMarketedAtToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :marketed_at, :datetime
  end
end
