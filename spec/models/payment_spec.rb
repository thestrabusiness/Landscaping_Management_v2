require 'rails_helper'

describe Payment do

  describe 'associations' do
    it { should belong_to(:client) }
    it { should belong_to(:invoice) }
  end

  describe 'validations' do
    let!(:payment) { create(:payment, invoice: build(:invoice), client: build(:client))}
    it {should validate_presence_of(:amount)}
    it {should validate_presence_of(:payment_type)}
    it {should validate_presence_of(:client)}
    it {should validate_presence_of(:invoice)}
  end
end
