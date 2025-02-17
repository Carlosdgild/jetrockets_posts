# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreatePostService, type: :service do
  let(:valid_params) do
    {
      title: 'New Post',
      body: 'Post content',
      login: 'user123',
      ip: '192.168.0.1'
    }
  end

  let(:invalid_params) do
    {
      title: '',
      body: '',
      login: '',
      ip: '192.168.0.1'
    }
  end

  let(:user) { instance_double(User, login: valid_params[:login]) }

  describe '#call!' do
    context "when the user doesn't exist and needs to be created" do
      it 'creates a new user and a new post' do
        expect(User.count).to eq(0)
        expect(Post.count).to eq(0)
        expect(User).to receive(:find_or_create_by!).with(login: valid_params[:login]).and_call_original
        expect(Post).to receive(:create!).and_call_original
        result = described_class.call!(valid_params)
        # validating result
        expect(result.class.name).to eq('Post')
        expect(result.title).to eq(valid_params[:title])
        expect(result.body).to eq(valid_params[:body])
        expect(result.ip).to eq(valid_params[:ip])
        expect(result.user.login).to eq(valid_params[:login])
        # Verifying database records
        expect(User.count).to eq(1)
        expect(Post.count).to eq(1)
      end
    end

    context 'when the user already exists' do
      it 'finds the existing user and creates a post' do
        user = User.create(login: 'user123')

        expect(User).to receive(:find_or_create_by!).and_call_original
        result = described_class.call!(valid_params)
        # validating result
        expect(result.class.name).to eq('Post')
        expect(result.title).to eq(valid_params[:title])
        expect(result.body).to eq(valid_params[:body])
        expect(result.ip).to eq(valid_params[:ip])
        expect(result.user_id).to eq(user.id)
        # Verifying database records
        expect(User.count).to eq(1)
        expect(Post.count).to eq(1)
      end

      it 'when did not find a user and tries to create a new one, but another process create it' do
        user = User.create(login: 'user123')

        allow(User).to receive(:find_or_create_by!).and_raise(ActiveRecord::RecordNotUnique)
        expect(User).to receive(:find_by).with(login: 'user123').and_call_original
        result = described_class.call!(valid_params)
        # validating result
        expect(result.class.name).to eq('Post')
        expect(result.title).to eq(valid_params[:title])
        expect(result.body).to eq(valid_params[:body])
        expect(result.ip).to eq(valid_params[:ip])
        expect(result.user_id).to eq(user.id)
        # Verifying database records
        expect(User.count).to eq(1)
        expect(Post.count).to eq(1)
      end
    end

    context 'when post creation fails' do
      it 'raises ActiveRecord::RecordInvalid error' do
        allow(Post).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(Post.new))
        # Verificamos que la excepción es lanzada
        expect do
          described_class.call!(valid_params)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when invalid parameters are passed' do
      it 'raises validation errors' do
        expect do
          described_class.call!(invalid_params)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
