require 'open-uri'
require 'json'

class GamesController < ApplicationController

  Rails.application.config.session_store :cookie_store, key: 'session'

  def new
    vowels = ['A', 'E', 'I', 'O', 'U']
    letters = ('A'..'Z').to_a - vowels
    @letters = []
    6.times{ @letters << letters.sample }
    4.times{ @letters << vowels.sample }
    @letters = @letters.shuffle
    session[:current_score] = 0 if session[:current_score].nil?
  end

  def score
    word = params[:word]
    letters = params[:letters].split(" ")
    @result_string = check_attempt(word, letters)
    calculate_score(word)
  end

  def english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary_response = open(url).read
    resulting_hash = JSON.parse(dictionary_response)
    if resulting_hash["found"]
      return "Congratulations! '#{attempt}' is a valid English word!"
    else
      return "Sorry but #{attempt} does not seem to be a valid english word..."
    end
  end

  def check_attempt(attempt, grid)
    if attempt.upcase.chars.all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
      return english?(attempt)
    else
      return "Sorry but #{attempt} can't be built out of #{grid.join(", ")}"
    end
  end

  def calculate_score(attempt)
    # return 0 if total_time > 30
    # score = attempt.length * (30 / total_time)
    session[:current_score] += attempt.length**2
  end
end

# def run_game(attempt, grid, start_time, end_time)
#   game_hash = {}
#   game_hash[:message] = check_attempt(attempt, grid)
#   game_hash[:time] = (end_time - start_time).round(2)
#   game_hash[:score] = calculate_score(attempt, game_hash[:time]).round(2)

#   game_hash[:message] = "You must answer faster next time" if game_hash[:time] > 30

#   game_hash[:score] = 0 if game_hash[:message][0..2] == "not"

#   return game_hash
#   # TODO: runs the game and return detailed hash of result
# end
