FactoryGirl.define do
  factory :address do
    street '24 Marion Road'
    city 'Belmont'
    state 'MA'
    zip '02478'
    client { build(:client) }
  end
end
