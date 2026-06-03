module Spree
  module TaxonDecorator
    # find_by_store_id_and_permalink! was a `def self.` on the prepended module,
    # which prepend never exposes on the host class (NoMethodError). Move it into
    # a ClassMethods module prepended onto the singleton class.
    # (mirrors solidusio-contrib/solidus_multi_domain#172)
    def self.prepended(base)
      base.singleton_class.prepend ClassMethods
    end

    module ClassMethods
      def find_by_store_id_and_permalink!(store_id, permalink)
        joins(:taxonomy).where("spree_taxonomies.store_id = ?", store_id).where(permalink: permalink).first!
      end
    end

    ::Spree::Taxon.prepend(self)
  end
end
