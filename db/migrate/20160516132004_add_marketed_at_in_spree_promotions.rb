class AddMarketedAtInSpreePromotions < ActiveRecord::Migration
  def change
    add_column :spree_promotions, :marketed_at, :datetime
  end
end
