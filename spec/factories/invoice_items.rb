FactoryGirl.define do
  factory :invoice_item do
    name              ['Cut', 'Mulch', 'Bushes'].sample
    price             [150, 75, 25, 200].sample
    quantity          1
  end
end
