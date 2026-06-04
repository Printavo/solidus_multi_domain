# spree_store_shipping_methods ships in Solidus core since v2.6 (and in the Printavo
# fork), so guard the create-table to avoid colliding with the host app's schema.
# (mirrors solidusio-contrib/solidus_multi_domain#93, e304c025)
class AddStoreShippingMethods < SolidusSupport::Migration[4.2]
  def self.up
    return if table_exists?(:spree_store_shipping_methods)

    create_table :spree_store_shipping_methods do |t|
      t.integer :store_id
      t.integer :shipping_method_id

      t.timestamps null: true
    end

    add_index :spree_store_shipping_methods, :store_id
    add_index :spree_store_shipping_methods, :shipping_method_id
  end

  def self.down
    drop_table :spree_store_shipping_methods
  end
end
