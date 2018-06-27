class AddMarketedAtInSpreePromotions < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_promotions, :marketed_at, :datetime
  end
end
