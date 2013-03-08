module SpreePaymentCalculator
  class Engine < Rails::Engine
    engine_name 'spree_payment_calculator'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/overrides/*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end
    
    initializer 'spree.register.calculators' do |app|

      app.config.spree.calculators.add_class('payment_methods')
      app.config.spree.calculators.add_class('gateways')

      app.config.spree.calculators.payment_methods = [
        Spree::PaymentCalculator::DefaultTax,
        Spree::PaymentCalculator::PriceSack,
        Spree::PaymentCalculator::FlatPercentItemTotal,
        Spree::PaymentCalculator::FlatRate,
        Spree::PaymentCalculator::FlexiRate,
        Spree::PaymentCalculator::PerItem
      ]

      app.config.spree.calculators.gateways = [
        Spree::PaymentCalculator::DefaultTax,
        Spree::PaymentCalculator::PriceSack,
        Spree::PaymentCalculator::FlatPercentItemTotal,
        Spree::PaymentCalculator::FlatRate,
        Spree::PaymentCalculator::FlexiRate,
        Spree::PaymentCalculator::PerItem
      ]
    end

    config.to_prepare &method(:activate).to_proc
  end
end
