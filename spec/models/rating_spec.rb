# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    context 'with range validation' do
      it 'is valid with a value between 1 and 5' do
        rating = described_class.new(post: create(:post), user: create(:user), value: 3)
        expect(rating).to be_valid
      end

      it 'is invalid with a value less than 1' do
        rating = described_class.new(post: create(:post), user: create(:user), value: 0)
        expect(rating).to be_invalid
        expect(rating.errors[:value]).to include('must be between 1 and 5')
      end

      it 'is invalid with a value greater than 5' do
        rating = described_class.new(post: create(:post), user: create(:user), value: 6)
        expect(rating).to be_invalid
        expect(rating.errors[:value]).to include('must be between 1 and 5')
      end

      it 'is invalid without a value' do
        rating = described_class.new(post: create(:post), user: create(:user), value: nil)
        expect(rating).to be_invalid
        expect(rating.errors[:value]).to include('must be between 1 and 5')
      end
    end

    context 'when user validation' do
      it 'is invalid without a user' do
        rating = build(:rating, user: nil)
        expect(rating).to be_invalid
        expect(rating.errors[:user]).to include('must exist')
      end
    end

    context 'when post validation' do
      it 'is invalid without a post' do
        rating = build(:rating, post: nil)
        expect(rating).to be_invalid
        expect(rating.errors[:post]).to include('must exist')
      end
    end
  end

  describe 'acts_as_paranoid' do
    let(:rating) { create :rating }

    it 'adds deleted_at to record' do
      rating.destroy
      expect(rating.deleted_at).to be_present
      expect(rating).to be_deleted
    end

    it 'does not find "deleted_at" in record after it has been restored' do
      rating.destroy
      expect(rating.deleted_at).to be_present
      expect(rating).to be_deleted
      rating.restore
      expect(rating.deleted_at).to be_nil
      expect(rating).not_to be_deleted
    end
  end
end
