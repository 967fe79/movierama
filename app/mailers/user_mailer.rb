class UserMailer < ActionMailer::Base

  def movie_vote(movie, voter, like_or_hate)
    @movie = movie
    @recipient = movie.user
    @voter = voter
    @verbed = voting_verb(like_or_hate)

    mail(to: @recipient.email, subject: "Someone #{@verbed} your movie")
  end

  private

  def voting_verb(like_or_hate)
    case like_or_hate
      when :like then 'liked'
      when :hate then 'hated'
      else raise
    end
  end
end
