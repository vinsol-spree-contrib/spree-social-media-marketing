class AddMarketedAtToSpreeProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :marketed_at, :datetime
  end
end
