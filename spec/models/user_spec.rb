require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a gender' do
      user.gender = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a constituency_id' do
      user.constituency_id = nil
      expect(user).to_not be_valid
    end
  end

  describe 'associations' do
    # Assuming User has a belongs_to association with Constituency
    it 'has one constituency' do
      assoc = described_class.relations['constituency']
      expect(assoc).to be_present
      expect(assoc.relation).to eq Mongoid::Association::Referenced::HasOne::Proxy
    end
  end  
end
