module Spree
  module LineItemDecorator
    def prepend(base)
      base.include(SpreeMultiDomain::LineItemConcerns)
    end

    Spree::LineItem.prepend self
  end
end
