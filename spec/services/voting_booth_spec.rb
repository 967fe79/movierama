require 'rails_helper'

RSpec.describe VotingBooth do

  let(:voter) {
    User.create(id: 2, name: 'Voter Name', email: 'voter@example.com')
  }

  let(:user) {
    User.create(id: 1, name: 'Recipient Name', email: 'recipient@example.com')
  }

  let(:movie) {
    Movie.create(id: 1, title: 'Blade runner', user: user)
  }

  let(:voting_booth) {
    VotingBooth.new(voter, movie)
  }

  describe "Voting on a movie" do
    it "should send an email to the user who added the movie" do
      mail = double(Mail::Message)
      expect(mail).to receive(:deliver)

      expect(UserMailer).to receive(:movie_vote)
        .with(movie, voter, :like)
        .and_return(mail)

      voting_booth.vote(:like)
    end
  end
end
