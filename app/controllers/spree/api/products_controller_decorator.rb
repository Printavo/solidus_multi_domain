module Spree
  module Api
    module ProductsControllerDecorator
      def self.prepended(base)
        base.include(SpreeMultiDomain::ShowProductSupport)
      end

      Spree::Api::ProductsController.prepend(self) if SpreeMultiDomain::Engine.api_available?
    end
  end
end
