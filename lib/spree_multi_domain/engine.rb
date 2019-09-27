module SpreeMultiDomain
  class Engine < Rails::Engine
    engine_name 'solidus_multi_domain'

    config.autoload_paths += %W(#{config.root}/lib)

    class << self
      def activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require_dependency(c) : load(c)
        end

        Spree::Config.searcher_class = Spree::Search::MultiDomain

        require "solidus_multi_domain/multi_domain_helpers"
        ApplicationController.send :include, SolidusMultiDomain::MultiDomainHelpers
      end

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

    config.to_prepare &method(:activate).to_proc

    initializer "current order decoration" do |app|
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
      app.config.spree.promotions.rules << Spree::Promotion::Rules::Store
    end
  end
end
