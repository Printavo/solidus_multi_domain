module Spree
  module Api
    module ProductsControllerDecorator
      def prepend(base)
        base.include(SpreeMultiDomain::ShowProductSupport)
      end

      Spree::Api::ProductsControllerDecorator.prepend(self) if SpreeMultiDomain::Engine.api_available?
    end
  end
end
