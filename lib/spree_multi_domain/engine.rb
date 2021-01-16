module SpreeMultiDomain
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace Spree
    engine_name 'solidus_multi_domain'

    config.autoload_paths += %W(#{config.root}/lib)

    class << self
      def admin_available?
        const_defined?('Spree::Backend::Engine')
      end

      def api_available?
        const_defined?('Spree::Api::Engine')
      end

      def frontend_available?
        const_defined?('Spree::Frontend::Engine')
      end
    end

    config.to_prepare do
      require "solidus_multi_domain/multi_domain_helpers"
      ApplicationController.send :include, SolidusMultiDomain::MultiDomainHelpers
    end

    initializer "current order decoration" do |app|
      Spree::Config.searcher_class = "Spree::Search::MultiDomain"

      require 'spree/core/controller_helpers/order'
      ::Spree::Core::ControllerHelpers::Order.prepend(Module.new do
          def current_order_with_multi_domain(options = {})
            options[:create_order_if_necessary] ||= false
            current_order_without_multi_domain(options)

            if @current_order and current_store and @current_order.store.blank?
              @current_order.update_attribute(:store_id, current_store.id)
            end

            @current_order
          end
        end)
    end

    initializer 'spree.promo.register.promotions.rules' do |app|
      app.config.spree.promotions.rules << "Spree::Promotion::Rules::Store"
    end
  end
end
