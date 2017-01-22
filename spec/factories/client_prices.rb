FactoryGirl.define do
  factory :client_price do
    name    'Cut'
    price   200
    client  { build(:client)}
  end
end
