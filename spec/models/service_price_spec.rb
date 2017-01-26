require 'rails_helper'

describe ServicePrice do

  describe 'associations' do
    it {should belong_to(:client)}
  end

  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:price)}
    it {should validate_presence_of(:client)}
  end

end
