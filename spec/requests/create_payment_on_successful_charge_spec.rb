require 'spec_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      "id"=> "evt_1855LzFvLN3VTDgcVXS5J9d5",
      "object"=> "event",
      "api_version"=> "2015-10-16",
      "created"=> 1461812291,
      "data"=> {
        "object"=> {
          "id"=> "ch_1855LzFvLN3VTDgcy8fYuU52",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application_fee"=> nil,
          "balance_transaction"=> "txn_1855LzFvLN3VTDgcuPyE2vOn",
          "captured"=> true,
          "created"=> 1461812291,
          "currency"=> "usd",
          "customer"=> "cus_8LmvPxgHFtMN9I",
          "description"=> nil,
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> nil,
          "failure_message"=> nil,
          "fraud_details"=> {},
          "invoice"=> "in_1855LzFvLN3VTDgc8FBk46Op",
          "livemode"=> false,
          "metadata"=> {},
          "order"=> nil,
          "paid"=> true,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_1855LzFvLN3VTDgcy8fYuU52/refunds"
          },
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_1855LwFvLN3VTDgc9D9sU0D5",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_zip_check"=> nil,
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_8LmvPxgHFtMN9I",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 5,
            "exp_year"=> 2017,
            "fingerprint"=> "sEwzRtht8iK2udxn",
            "funding"=> "credit",
            "last4"=> "4242",
            "metadata"=> {},
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "source_transfer"=> nil,
          "statement_descriptor"=> "MyFlix Base Plan 2",
          "status"=> "succeeded"
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_8LmvxfqIEL2pwN",
      "type"=> "charge.succeeded"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded" do
    VCR.use_cassette('creates_payment_on_successful_charge') do
      post '/stripe_events', event_data
      expect(Payment.count).to eq(1)
    end
  end

  it "creates the payment associated with the user" do
    VCR.use_cassette('creates_payment_on_successful_charge') do
      alice = Fabricate(:user, customer_token: "cus_8LmvPxgHFtMN9I")
      post '/stripe_events', event_data
      expect(Payment.first.user).to eq(alice)
    end
  end

  it "creates the payment with the purchase amount" do
    VCR.use_cassette('creates_payment_on_successful_charge') do
      alice = Fabricate(:user, customer_token: "cus_8LmvPxgHFtMN9I")
      post '/stripe_events', event_data
      expect(Payment.first.amount).to eq(999)
    end
  end

  it "creates the payment with the reference id" do
    VCR.use_cassette('creates_payment_on_successful_charge') do
      alice = Fabricate(:user, customer_token: "cus_8LmvPxgHFtMN9I")
      post '/stripe_events', event_data
      expect(Payment.first.reference_id).to eq("ch_1855LzFvLN3VTDgcy8fYuU52")
    end
  end
end
