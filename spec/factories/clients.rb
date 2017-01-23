FactoryGirl.define do
  factory :client do
    sequence(:first_name) { |n| "Anthony #{n}"}
    last_name 'Moffa'
    sequence(:email) { |n| "moffa.an+test#{n}@gmail.com"}
    phone_number '9787663585'

    trait :with_billing_address do
      after :create do |client, evaluator|
        address = create(:address, client: client)
        client.update(billing_address: address)
      end
    end
  end
end
