require 'rails_helper'

describe InvoiceItem do

  describe 'associations' do
    it { should belong_to(:invoice)}
  end

  describe 'validations' do
    let!(:invoice_item) { create(:invoice_item, invoice: build(:invoice)) }
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:price)}
    it { should validate_presence_of(:quantity)}
    it { should validate_presence_of(:invoice)}
  end
end
