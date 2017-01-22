FactoryGirl.define do
  factory :invoice do
    total         1500
    job_date      Time.current
    performed_by  'Anthony'
    notes         'Good job'
    status        'PENDING'
    client        { create(:client) }

    trait :with_invoice_items do
      after :create do |invoice, evaluator|
        rand(3..5).times do
          create(:invoice_item, invoice: invoice)
        end
      end
    end

  end
end
