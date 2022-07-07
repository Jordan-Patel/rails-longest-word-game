require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = (0...9).map { rand(65..90).chr }
  end

  def score
    @word = params[:word]
    @letters_as_string = params[:letters]
    @letters = @letters_as_string.split
    @result = run_game(@word, @letters)
  end

  private

  def word_exists(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    JSON.parse(URI.open(url).read)
  end

  def word_in_grid(word, letters)
    # check if letters in word are in the grid
    word_letters_tally = word.upcase.chars.tally
    letters_tally = letters.tally
    word_letters_tally.all? { |k, v| letters_tally[k].to_i >= v }
  end

  def run_game(word, letters)
    @result = { score: 0 }

    if word_in_grid(word, letters) == false
      @result[:message] = "Sorry, that's not in the grid!"
    elsif word_exists(word)["found"] == false
      @result[:message] = "Sorry, that's not an English word!"
    elsif word_exists(word) || word_in_grid(word, grid)
      @result[:score] = (word.length)
      @result[:message] = "Well done!"
    end
    @result
  end

end
