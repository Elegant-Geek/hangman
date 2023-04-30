# check if file exists
# puts File.exists?('words.txt')


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


module Words
  # select a random word from the WORDBANK:
  # note: the private is needed here so you can't call gamename.select_word from the console!
  private
  def select_word
    # remove the newline break from the chosen word
    chosen_word = WORDBANK.sample
  end
end

class Game
  include Words
  def initialize(name="hangman")
    @name = name
    puts "New game called '#{@name}' created."
  end
  def test()
    # puts WORDBANK.select {|word| word.length <= 5}
  
  end
  def play_game()
    # store the secret word in an instance variable that captures the output from the select_word() module method
    @secret_word = select_word()
    puts "The word to guess has been selected (#{@secret_word.length} letters)."
    puts "THE SECRET WORD IS '#{@secret_word}'."
  end
end

game = Game.new()
game.play_game