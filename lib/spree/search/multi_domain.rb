module Spree::Search
  class MultiDomain < Spree::Core::Search::Base
    class MissingStoreIDError < RuntimeError; end

    def get_base_scope
      raise MissingStoreIDError unless @properties[:current_store_id].present?

      base_scope = Spree::Product.available.by_store(@properties[:current_store_id])
      base_scope = base_scope.in_taxon(@properties[:taxon]) unless @properties[:taxon].blank?

      base_scope = get_products_conditions_for(base_scope, @properties[:keywords]) unless @properties[:keywords].blank?

      base_scope = add_search_scopes(base_scope)
      base_scope
    end

    def prepare(params)
      super

      @properties[:current_store_id] = params[:current_store_id]
    end
  end
end
