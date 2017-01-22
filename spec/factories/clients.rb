FactoryGirl.define do
  factory :client do
    first_name 'Anthony'
    last_name 'Moffa'
    email 'moffa.an@gmail.com'
    phone_number '9787663585'

    trait :with_billing_address do
      after :create do |client, evaluator|
        address = create(:address, client: client)
        client.update(billing_address: address)
      end
    end
  end
end
