module Spree
  module HomeControllerDecorator
    def index
      @searcher = build_searcher(params.merge(include_images: true, deactivated: false))
      @products = @searcher.retrieve_products
      @taxonomies = get_taxonomies
    end

    ::Spree::HomeController.prepend(self) if SpreeMultiDomain::Engine.frontend_available?
  end
end
