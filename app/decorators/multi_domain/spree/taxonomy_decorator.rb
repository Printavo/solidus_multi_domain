module MultiDomain
  module Spree
    module TaxonomyDecorator
      def self.prepended(base)
        base.belongs_to :store
      end

      ::Spree::Taxonomy.prepend(self)
    end
  end
end
