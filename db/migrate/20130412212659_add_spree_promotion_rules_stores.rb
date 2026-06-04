# spree_promotion_rules_stores ships in Solidus core since v2.6 (and in the Printavo
# fork), so guard the create-table to avoid colliding with the host app's schema.
# (mirrors solidusio-contrib/solidus_multi_domain#93, e304c025)
class AddSpreePromotionRulesStores < SolidusSupport::Migration[4.2]
  def self.up
    return if table_exists?(:spree_promotion_rules_stores)

    create_table :spree_promotion_rules_stores, :id => false do |t|
      t.references :promotion_rule
      t.references :store
    end
  end

  def self.down
    drop_table :spree_promotion_rules_stores
  end
end
