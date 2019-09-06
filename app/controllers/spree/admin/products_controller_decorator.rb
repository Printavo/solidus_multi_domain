module Spree
  module Admin
    module ProductsControllerDecorator
      def self.prepended(base)
        base.update.before :set_stores
      end

      def set_stores
        # Remove all store associations if store data is being passed and no stores are selected
        if params[:update_store_ids] && !params[:product].key?(:store_ids)
          @product.stores.clear
        end
      end

      Spree::Admin::ProductsController.prepend(self) if SpreeMultiDomain::Engine.admin_available?
    end
  end
end
