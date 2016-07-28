require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 1,
        :exp_year => 2017,
        :cvc => "314"
      },
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 1,
        :exp_year => 2017,
        :cvc => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        VCR.use_cassette('create_stripe_charge') do
          response = StripeWrapper::Charge.create(
            amount: 999,
            source: valid_token,
            description: 'a valid charge'
          )
          expect(response).to be_successful
        end
      end

      it "makes a card declined charge" do
        VCR.use_cassette('declined_charge') do
          response = StripeWrapper::Charge.create(
            amount: 999,
            source: declined_card_token,
            description: 'an invalid charge'
          )
          expect(response).not_to be_successful
        end
      end

      it "returns the error message for a declined charge", :vcr do
        VCR.use_cassette('declined_charge') do
          response = StripeWrapper::Charge.create(
            amount: 999,
            source: declined_card_token,
            description: 'an invalid charge'
          )
          expect(response.error_message).to be_present
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      it 'creates a customer with a valid card', :vcr do
        VCR.use_cassette('create_customer') do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: valid_token
          )
          expect(response).to be_successful
        end
      end

      it 'does not create a customer with a declined card', :vcr do
        VCR.use_cassette('decline_customer') do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: declined_card_token
          )
          expect(response).not_to be_successful
        end
      end

      it 'returns the error message for a declined card', :vcr do
        VCR.use_cassette('decline_customer') do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: declined_card_token
          )
          expect(response.error_message).to be_present
        end
      end

      it 'returns the customer token from stripe with a valid charge' do
        VCR.use_cassette('returns_customer_token_for_valid_charge') do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: valid_token
          )
          expect(response.customer_token).to be_present 
        end
      end
    end
  end
end
