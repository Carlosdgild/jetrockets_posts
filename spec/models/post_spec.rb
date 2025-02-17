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
    let(:post) { create :post }

    it 'adds deleted_at to record' do
      post.destroy
      expect(post.deleted_at).to be_present
      expect(post).to be_deleted
    end

    it 'does not find "deleted_at" in record after it has been restored' do
      post.destroy
      expect(post.deleted_at).to be_present
      expect(post).to be_deleted
      post.restore
      expect(post.deleted_at).to be_nil
      expect(post).not_to be_deleted
    end
  end

  describe '.retrieve_post_by_average' do
    let!(:post) { create :post }

    it 'returns only posts that have rating' do
      create :rating
      result = described_class.retrieve_post_by_average(10)
      expect(result.length).to eq(1)
      expect(result.first.id).not_to eq(post.id)
    end
  end
end
