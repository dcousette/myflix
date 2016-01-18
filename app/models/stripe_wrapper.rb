module StripeWrapper
  class Charge
    def self.create(options={})
      begin
        Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          source: options[:source],
          description: options[:description]
        )
      rescue Stripe::CardError => e
        #Your card has been declined
      end
    end
  end
end
