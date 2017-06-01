require 'rails_helper'

describe EstimateItem do

  describe 'associations' do
    it { should belong_to(:estimate)}
  end

  describe 'validations' do
    let!(:estimate_item) { create(:estimate_item, estimate: build(:estimate)) }
    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:price)}
    it { should validate_presence_of(:quantity)}
    it { should validate_presence_of(:estimate)}
  end
end
