require 'yaml'

class Game
  attr_accessor :word, :guess_display, :guessed_letters, :turns, :solved

  def initialize
    puts 'Welcome to Hangman! You will have 6 tries to guess a word.'
    puts 'Would you like to start a new game or load an old one? Type "new" or "load"'
    input = gets.chomp
    new_game if input == 'new'
    load_game if input == 'load'
  end

  def load_game
    puts 'What is the name of the game you want to load? Here are the existing games:'
    p Dir.entries('./saved_games')
    loaded = gets.chomp
    game_file = File.open(File.join(Dir.pwd, "/saved_games/#{loaded}"), 'r'){|f| f.read }
    game = YAML.load(game_file)
    puts "Game loaded!\nWord Progress: #{game.guess_display}\nYou've guessed: #{game.guessed_letters}\nYou've used #{game.turns - 1} turns"
    game.play
  end

  def new_game
    @solved = false
    @turns = 0
    @word = ''
    @word = File.readlines('./lib/words.txt').sample.chomp.split('') until word.length > 4 && word.length < 13
    @guess_display = Array.new(@word.length, '_')
    @guessed_letters = []
    play
  end

  def save
    puts 'Name your saved game'
    filename = gets.chomp
    File.open(File.join(Dir.pwd, "/saved_games/#{filename}"), 'w') { |file| file.write(self.to_yaml) }
    puts 'Game Saved'
    return
  end

  def play
    puts 'You will get 10 guesses at letters to help you guess the computer\'s word. After each guess, you will get
    feedback to see if your letter is in the word.'.chomp
    turn
  end

  def turn
    while solved == false && turns < 10
      self.turns += 1
      p "Guess number #{turns}. Enter your letter guess"
      guess = gets.chomp.downcase
      if guess == '!'
        save
        break
      end
      update_guess(guess)
      post_turn
    end
  end

  def update_guess(guess)
    guessed_letters << guess
    word.each_with_index {|_v, i| guess_display[i] = word[i] if word[i] == guess}
  end

  def post_turn
    puts "Word Progress: #{guess_display}. You've guessed these letters: #{guessed_letters}"
    puts 'Type "!" if you would like to save.'
    if guess_display == word
      self.solved = true
      p 'Congratulations! You guessed it!'
      again
    end
    return unless turns == 10 && guess_display != word
    again
  end

  def again
    if solved == false
      puts "Looks like you didn't get it! The word was #{word.join()}. Try again? Type 'Y' if so: " 
    else
      puts "Would you like to play again? Type 'Y' if so: "
    end
    new_game if gets.chomp == 'Y'
  end

end

Game.new