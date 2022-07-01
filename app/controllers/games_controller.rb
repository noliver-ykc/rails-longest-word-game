# frozen_string_literal: true

require 'open-uri'

# controller for games
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(9)
  end

  def score
    @input = params[:word]
    @letters = params[:letters]

    if @input.present?
      check_letters_match(@letters, @input)
    else
      @input_please = 'Please input a word and try again'
    end
  end

  def check_letters_match(letters, input)
    input = input.upcase

    match = input.chars.all? { |char| input.count(char) <= letters.count(char) }

    if match == false
      @no_match = "Sorry but #{input} cannot be built out of #{letters}"
    else
      check_valid_word(input)
    end
  end

  def check_valid_word(input)
    url = "https://wagon-dictionary.herokuapp.com/#{input}.json"
    json = JSON.parse(URI.open(url).read)
    @dictionary_result = if json['found'] == true
                           "#{input} is a valid English word!"
                         else
                           "Sorry but #{input} does not seem to be a valid English word..."
                         end
  end
end
