module Spree
  module ProductsControllerDecorator
    def self.prepended(base)
      base.include(SpreeMultiDomain::ShowProductSupport)
    end

    Spree::ProductsController.prepend(self) if SpreeMultiDomain::Engine.frontend_available?
  end
end
