# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:ratings).dependent(:destroy) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:login) }

    it 'is invalid with a duplicate login' do
      create(:user, login: 'unique_login')
      user2 = build(:user, login: 'unique_login')
      expect(user2).not_to be_valid
      expect(user2.errors[:login]).to include('has already been taken')
    end
  end

  describe 'acts_as_paranoid' do
    let(:user) { create :user }

    it 'adds deleted_at to record' do
      user.destroy
      expect(user.deleted_at).to be_present
      expect(user).to be_deleted
    end

    it 'does not find "deleted_at" in record after it has been restored' do
      user.destroy
      expect(user.deleted_at).to be_present
      expect(user).to be_deleted
      user.restore
      expect(user.deleted_at).to be_nil
      expect(user).not_to be_deleted
    end
  end
end
