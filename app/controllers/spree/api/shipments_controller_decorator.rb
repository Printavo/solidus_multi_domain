module Spree
  module Api
    module ShipmentsControllerDecorator
      def mine
        super

        @shipments = @shipments.where(spree_orders: { store_id: current_store.id }) if @shipments
      end

      if SpreeMultiDomain::Engine.api_available?
        Spree::Api::ShipmentsController.prepend(Spree::Api::ShipmentsControllerDecorator)
        Spree::Api::ShipmentsController.include(SpreeMultiDomain::CreateLineItemSupport)
      end
    end
  end
end
