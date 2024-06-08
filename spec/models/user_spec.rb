require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    let(:user) { build(:user) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a gender' do
      user.gender = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a constituency_id' do
      user.constituency_id = nil
      expect(user).not_to be_valid
    end
  end
  # let(:user) { build(:user) }

  # describe 'validations' do
  #   it 'is valid with valid attributes' do
  #     expect(user).to be_valid
  #   end

  #   it 'is not valid without a name' do
  #     user.name = nil
  #     expect(user).to_not be_valid
  #   end

  #   it 'is not valid without a gender' do
  #     user.gender = nil
  #     expect(user).to_not be_valid
  #   end

  #   it 'is not valid without a constituency_id' do
  #     user.constituency_id = nil
  #     expect(user).to_not be_valid
  #   end
  # end

  # describe 'associations' do
  #   # Assuming User has a belongs_to association with Constituency
  #   it 'belongs to a constituency' do
  #     assoc = described_class.reflect_on_association(:constituency)
  #     expect(assoc.macro).to eq :belongs_to
  #   end
  # end
end
