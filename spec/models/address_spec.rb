require 'rails_helper'

describe Address do

  describe 'associations' do
    it {should belong_to(:client)}
  end

  describe 'validations' do
    let!(:address) { create(:address )}
    it { should validate_presence_of(:street)}
    it { should validate_presence_of(:city)}
    it { should validate_presence_of(:state)}
    it { should validate_presence_of(:zip)}
    it { should validate_presence_of(:client)}
  end
end
