require_dependency 'spree/calculator'

module Spree
  class PaymentCalculator::PercentOrMinimalPrice < Calculator
    preference :minimal_price, :decimal, :default => 0
    preference :percent, :decimal, :default => 0

    attr_accessible :preferred_minimal_price, :preferred_percent

    def self.description
      I18n.t(:percent_or_minimal_price)
    end

    def compute(object)
      return unless object.present? and object.respond_to?(:amount)
      item_total = object.amount
      amount = item_total * (self.preferred_percent * 1/100.0)
      if amount < self.preferred_minimal_price
        amount = self.preferred_minimal_price
      end
      amount
    end

  end
end