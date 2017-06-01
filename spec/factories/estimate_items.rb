FactoryGirl.define do
  factory :estimate_item do
    description       ['Install Pavers', 'Regular Maintenence', 'New Bushes'].sample
    price             [150, 75, 25, 200].sample
    quantity          [1,2,3].sample
  end
end
