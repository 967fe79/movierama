require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "movie_vote" do
    let(:recipient) {
      User.create(id: 1, name: 'Recipient Name', email: 'recipient@example.com')
    }

    let(:voter) {
      User.create(id: 2, name: 'Voter Name', email: 'voter@example.com')
    }

    let(:movie) {
      Movie.create(id: 1, title: 'Blade runner', user: recipient)
    }

    let(:like_or_hate) { :like }

    let(:mail) { UserMailer.movie_vote(movie, voter, like_or_hate) }

    it "renders the headers" do
      expect(mail.subject).to eq("Someone liked your movie")
      expect(mail.to).to eq(["recipient@example.com"])
      expect(mail.from).to eq(["no-reply@movierama.test"])
    end

    it "renders a multi-part body" do
      expect(mail.body.parts.length).to eq(2)
    end

    it "renders the plain body" do
      expect(mail.text_part.body.to_s).to include("Hi Recipient Name,")
      expect(mail.text_part.body.to_s).to include("Voter Name liked your movie: Blade runner")
    end

    it "renders the HTML body" do
      expect(mail.html_part.body.to_s).to include("<strong>Hi Recipient Name</strong>")
      expect(mail.html_part.body.to_s).to include("Voter Name liked your movie: Blade runner")
    end

    describe "when a voter hates a movie" do
      let(:like_or_hate) { :hate }

      it "uses the right verb" do
        expect(mail.subject).to eq("Someone hated your movie")
        expect(mail.body.encoded).to include("Hi Recipient Name,")
        expect(mail.body.encoded).to include("Voter Name hated your movie: Blade runner")
      end
    end
  end
end
