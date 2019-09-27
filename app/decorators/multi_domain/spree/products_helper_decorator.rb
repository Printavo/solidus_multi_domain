module MultiDomain
  module Spree
    module ProductsHelperDecorator
      def get_taxonomies
        @taxonomies ||= current_store.present? ? Spree::Taxonomy.where(["store_id = ?", current_store.id]) : Spree::Taxonomy
        @taxonomies = @taxonomies.includes(:root => :children)

        @taxonomies
      end

      ::Spree::ProductsHelper.include(self)
    end
  end
end
