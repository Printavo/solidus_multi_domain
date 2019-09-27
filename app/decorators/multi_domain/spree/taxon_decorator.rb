module MultiDomain
  module Spree
    module TaxonDecorator
      def self.find_by_store_id_and_permalink!(store_id, permalink)
        joins(:taxonomy).where("spree_taxonomies.store_id = ?", store_id).where(permalink: permalink).first!
      end

      ::Spree::Taxon.prepend(self)
    end
  end
end
