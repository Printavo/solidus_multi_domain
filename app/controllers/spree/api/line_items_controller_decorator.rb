module Spree
  module Api
    module LineItemsControllerDecorator
      def prepend(base)
        base.include(SpreeMultiDomain::CreateLineItemSupport)
      end

      Spree::Api::LineItemsController.prepend(self) if SpreeMultiDomain::Engine.api_available?
    end
  end
end
