module Spree
  module TaxonomyDecorator

    def prepend(base)
      base.belongs_to :store
    end

    Spree::Taxonomy.prepend self
  end
end
