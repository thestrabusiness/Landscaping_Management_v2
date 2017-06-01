require 'rails_helper'

describe Estimate do

  describe 'associations' do
    it { should have_one(:client)}
    it { should belong_to(:address)}
    it { should have_many(:estimate_items)}
  end

  describe 'validations' do
    let!(:estimate) { create(:estimate) }
    it { should validate_presence_of(:total)}
    it { should validate_presence_of(:date)}
    it { should validate_presence_of(:address)}
    it { should validate_presence_of(:client)}
  end
end
