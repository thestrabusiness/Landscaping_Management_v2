require 'rails_helper'

describe Service do
  describe 'validations' do
    let!(:service) { create(:service) }
    it { should validate_presence_of(:name)}
  end
end