# puts WORDBANK.select {|word| word.length <= 5}

WORDBANK = []
File.readlines('words.txt').each do |line|
  # remove any new line break things because the program will think it counts as a character! 
  # (8450 entries is bad and will include 4 letter words if you omit the gsub detail on line 8 below)
  # as of now, a 7556 size word pool is the correct one
  if line.gsub("\n",'').length.between?(5, 12)
    WORDBANK << line.gsub("\n",'')
  end
end
puts "The wordbank has #{WORDBANK.length} entries."

class Game
  def initialize(name="hangman")
    @name = name
    puts "New game called '#{@name}' created."
  end
  def show_display(displ)
    p displ.join(' ')
  end
  def generate_guesses(secret_word)
    if secret_word.length >= 9
      @guesses = 10
    else
      @guesses = 7
    end
  end

  def play_game()
    # store the secret word in an instance variable that captures the output from the select_word() module method
    @secret_word = WORDBANK.sample
    # display variable itself must be updated for every place in the array, so only join things to update the display in the console not on the display variable itself!
    @display = Array.new(@secret_word.length, "_")
    show_display(@display)
    puts "The word to guess is #{@secret_word.length} letters."
    puts "THE SECRET WORD IS '#{@secret_word}'."
    generate_guesses(@secret_word)

    puts "You have up to #{@guesses} incorrect guesses."
  end
end

game = Game.new()
game.play_game
