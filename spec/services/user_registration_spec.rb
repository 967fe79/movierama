require 'rails_helper'

RSpec.describe UserRegistration do

  let(:auth_hash) {
    {
      'provider' => 'github',
      'uid' => '12345',
      'info' => {
        'name' => 'foo',
        'email' => 'foo@example.com'
      }
    }
  }

  let(:user_reg) {
    UserRegistration.new(auth_hash)
  }

  describe "registering a new user" do
    it "should be newly created" do
      expect(user_reg.created?).to be true
    end

    it "should save their email address" do
      expect(user_reg.user.email).to eq('foo@example.com')
    end
  end

  describe "registering an existing user" do
    it "should be newly created" do
      expect(User).to receive(:find).and_return([User.new()])
      expect(user_reg.created?).to be false
    end

    it "should save their email address if missing" do
      expect(User).to receive(:find).and_return([User.new(email: nil)])
      expect(user_reg.user.email).to eq('foo@example.com')
    end

    it "should not update their email address if it's changed" do
      expect(User).to receive(:find).and_return([User.new(email: 'bar@example.com')])
      expect(user_reg.user.email).to eq('bar@example.com')
    end

  end
end
