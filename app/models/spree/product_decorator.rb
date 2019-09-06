module Spree
  module ProductDecorator
    def prepend(base)
      base.has_and_belongs_to_many :stores, :join_table => 'spree_products_stores'
      base.scope :by_store, lambda { |store| joins(:stores).where("spree_products_stores.store_id = ?", store) }
    end

    Spree::Product.prepend self
  end
end
