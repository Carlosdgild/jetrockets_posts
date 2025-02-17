# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:ratings).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:ip) }
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
