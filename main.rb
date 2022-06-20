class Game
  attr_accessor :word, :guess_display, :word_array, :guessed_letters

  def initialize
    puts 'Welcome to Hangman! You will have 6 tries to guess a word.'
    @word = 'x'
    until word.length > 4 && word.length < 13
      @word = File.readlines('./lib/words.txt').sample.chomp
    end
    puts @word
    @word_array = word.split('')
    @guess_display = Array.new(@word.length, '_')
    @guessed_letters = []
    play
  end

  def play
    solved = false
    turns = 1
    p 'You will get 6 guesses at letters to help you guess the computer\'s word. After each guess, you will get
    feedback to see if your letter is in the word.'.chomp
    while solved == false && turns < 7
      p "Guess number #{turns}"
      p 'Enter your letter guess'
      guess = gets.chomp.downcase
      guessed_letters.push(guess.chomp)
      word_array.each_with_index do |_v, i|
        guess_display[i] = word_array[i] if word_array[i] == guess
      end
      turns += 1
      puts "Word Progress: #{guess_display}"
      puts "You've guessed these letters: #{guessed_letters}"
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
