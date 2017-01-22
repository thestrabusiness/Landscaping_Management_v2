require 'rails_helper'

describe Client do

  describe 'associations' do
    it { should have_many(:addresses) }
    it { should have_many(:invoices) }
    it { should have_many(:client_prices) }
    it { should have_many(:payments) }
    it { should have_one(:billing_address).class_name('Address') }
  end

  describe 'validations' do
    let!(:client) { create(:client, :with_billing_address)}
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
    it { should validate_presence_of(:phone_number)}
  end
end
