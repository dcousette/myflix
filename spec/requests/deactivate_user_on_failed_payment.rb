require 'spec_helper'

describe 'deactivate user on failed payment' do
  let(:event_data) do
    {
      "id"=> "evt_188XYuFvLN3VTDgcwI0Qkxjc",
      "object"=> "event",
      "api_version"=> "2015-10-16",
      "created"=> 1462635708,
      "data"=> {
        "object"=> {
          "id"=> "ch_188XYuFvLN3VTDgcfAtOjd8g",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application_fee"=> nil ,
          "balance_transaction"=> nil ,
          "captured"=> false,
          "created"=> 1462635708,
          "currency"=> "usd",
          "customer"=> "cus_8OQLJyFTSmPmRS",
          "description"=> "Myflix subscription 2",
          "destination"=> nil ,
          "dispute"=> nil ,
          "failure_code"=> "card_declined",
          "failure_message"=> "Your card was declined.",
          "fraud_details"=> {},
          "invoice"=> nil ,
          "livemode"=> false,
          "metadata"=> {},
          "order"=> nil ,
          "paid"=> false,
          "receipt_email"=> nil ,
          "receipt_number"=> nil ,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_188XYuFvLN3VTDgcfAtOjd8g/refunds"
          },
          "shipping"=> nil ,
          "source"=> {
            "id"=> "card_188XTZFvLN3VTDgc9i3CWECq",
            "object"=> "card",
            "address_city"=> nil ,
            "address_country"=> nil ,
            "address_line1"=> nil ,
            "address_line1_check"=> nil ,
            "address_line2"=> nil ,
            "address_state"=> nil ,
            "address_zip"=> nil ,
            "address_zip_check"=> nil ,
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_8OQLJyFTSmPmRS",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil ,
            "exp_month"=> 5,
            "exp_year"=> 2018,
            "fingerprint"=> "JkWpo2Xo5vCmWxEp",
            "funding"=> "credit",
            "last4"=> "0341",
            "metadata"=> {},
            "name"=> nil ,
            "tokenization_method"=> nil
          },
          "source_transfer"=> nil ,
          "statement_descriptor"=> nil ,
          "status"=> "failed"
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_8PMHPyxMiZIYCS",
      "type"=> "charge.failed"
    }
  end

  it 'deactivates a user with the web hook data from stripe for charge failed in stripe' do
    VCR.use_cassette('deactivate_user_with_failed_charge') do
      jim = Fabricate(:user, customer_token: "cus_8OQLJyFTSmPmRS")
      post '/stripe_events', event_data
      expect(jim.reload).not_to be_active
    end
  end
end
