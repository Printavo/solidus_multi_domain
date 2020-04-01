module Spree::Search
  class MultiDomain < Spree::Core::Search::Base
    class MissingStoreIDError < RuntimeError; end

    def get_base_scope
      raise MissingStoreIDError unless @properties[:current_store_id].present?

      base_scope = Spree::Product.available.by_store(@properties[:current_store_id])
      base_scope = base_scope.in_taxon(@properties[:taxon]) if @properties[:taxon].present?
      base_scope = base_scope.where(deactivated: @properties[:deactivated]) unless @properties[:deactivated].nil?

      base_scope = get_products_conditions_for(base_scope, @properties[:keywords]) if @properties[:keywords].present?

      base_scope = add_search_scopes(base_scope)
      base_scope = base_scope.order(position: :asc)

      base_scope
    end

    def prepare(params)
      super

      @properties[:deactivated] = params[:deactivated]
      @properties[:current_store_id] = params[:current_store_id]
    end
  end
end
