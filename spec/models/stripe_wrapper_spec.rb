require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        VCR.use_cassette('create_stripe_charge') do
          token = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 1,
              :exp_year => 2017,
              :cvc => "314"
            },
          ).id

          response = StripeWrapper::Charge.create(
            amount: 999,
            source: token,
            description: 'a valid charge'
          )

          expect(response).to be_successful
        end
      end

      it "makes a card declined charge" do
        VCR.use_cassette('declined_charge') do
          token = Stripe::Token.create(
            :card => {
              :number => "4000000000000002",
              :exp_month => 1,
              :exp_year => 2017,
              :cvc => "314"
            },
          ).id

          response = StripeWrapper::Charge.create(
            amount: 999,
            source: token,
            description: 'an invalid charge'
          )

          expect(response).not_to be_successful
        end
      end

      it "returns the error message for a declined charge", :vcr do
        VCR.use_cassette('declined_charge') do
          token = Stripe::Token.create(
            :card => {
              :number => "4000000000000002",
              :exp_month => 1,
              :exp_year => 2017,
              :cvc => "314"
            },
          ).id

          response = StripeWrapper::Charge.create(
            amount: 999,
            source: token,
            description: 'an invalid charge'
          )

          expect(response.error_message).to be_present
        end
      end
    end
  end
end