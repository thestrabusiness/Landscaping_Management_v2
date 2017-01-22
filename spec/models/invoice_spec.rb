require 'rails_helper'

describe Invoice do

  describe 'associations' do
    it { should belong_to(:client)}
    it { should have_many(:payments)}
    it { should have_many(:invoice_items)}
  end

  describe 'validations' do
    let!(:invoice) { create(:invoice) }
    it { should validate_presence_of(:total)}
    it { should validate_presence_of(:job_date)}
    it { should validate_presence_of(:performed_by)}
    it { should validate_presence_of(:client)}
  end
end
