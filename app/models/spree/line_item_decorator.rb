module Spree
  module LineItemDecorator
    def self.prepended(base)
      base.include(SpreeMultiDomain::LineItemConcerns)
    end

    Spree::LineItem.prepend self
  end
end
