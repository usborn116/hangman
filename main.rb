require 'yaml'

class Game
  attr_accessor :word, :guess_display, :word_array, :guessed_letters, :turns

  def initialize
    puts 'Welcome to Hangman! You will have 6 tries to guess a word.'
    puts 'Would you like to start a new game or load an old one? Type "new" or "load"'
    input = gets.chomp
    new_game if input == 'new'
    if input == 'load'
      puts 'What is the name of the game you want to load? Here are the existing games:'
      p Dir.entries('./saved_games')
      loaded = gets.chomp
      game_file = File.open(File.join(Dir.pwd, "/saved_games/#{loaded}"), 'r') { |f| f.read}
      game = YAML.load(game_file)
      puts 'Game loaded!'
      puts "Word Progress: #{game.guess_display}"
      puts "You've guessed these letters: #{game.guessed_letters}"
      puts "You've used #{game.turns - 1} turns"
      game.play
    end
  end

  def new_game
    @word = 'x'
    @turns = 1
    until word.length > 4 && word.length < 13
      @word = File.readlines('./lib/words.txt').sample.chomp
    end
    @word_array = word.split('')
    @guess_display = Array.new(@word.length, '_')
    @guessed_letters = []
    play
  end

  def save
    puts "Name your saved game"
    filename = gets.chomp
    File.open(File.join(Dir.pwd, "/saved_games/#{filename}"), 'w') { |file| file.write(self.to_yaml)}
    puts 'Game Saved'
  end

  def play
    solved = false
    p 'You will get 6 guesses at letters to help you guess the computer\'s word. After each guess, you will get
    feedback to see if your letter is in the word.'.chomp
    while solved == false && turns < 7
      p "Guess number #{turns}"
      p 'Enter your letter guess'
      guess = gets.chomp.downcase
      @guessed_letters.push(guess.chomp)
      @word_array.each_with_index do |_v, i|
        guess_display[i] = word_array[i] if word_array[i] == guess
      end
      @turns += 1
      puts "Word Progress: #{guess_display}"
      puts "You've guessed these letters: #{guessed_letters}"
      puts 'Type "S" if you would like to save. Otherwise, hit enter'
      yes_save = gets.chomp
      if yes_save == 'S'
        save
        break
      end
      if guess_display == word_array
        solved = true
        p 'Congratulations! You guessed it!'
        break
      end
    end
    return unless turns == 7 && guess_display != word_array

    p "Looks like you didn't get it! Try again?"
  end
end

Game.new
