FactoryGirl.define do
  factory :estimate do
    total         1500
    date      Time.current
    notes         'Good job'
    address        { create(:address) }

    trait :with_estimate_items do
      after :create do |estimate, _|
        rand(3..5).times do
          create(:estimate_item, estimate: estimate)
        end
      end
    end
  end
end
