# 4.30.23 5:50pm – 11:40pm 
require 'yaml'
WORDBANK = []
File.readlines('words.txt').each do |line|
  # remove any new line break things because the program will think it counts as a character! 
  # (8450 entries is bad and will include 4 letter words if you omit the gsub detail on line 8 below)
  # as of now, a 7556 size word pool is the correct one
  if line.gsub("\n",'').length.between?(5, 12)
    WORDBANK << line.gsub("\n",'')
  end
end

def load_game()
  if File.exists?('hangman.yaml')
  filename = 'hangman.yaml'
  saved = File.open(File.join(Dir.pwd, filename), 'r')
  loaded_game = YAML.load(saved)
  saved.close
  puts loaded_game
  puts loaded_game.inspect
  loaded_game

else
puts "Could not load game. Creating a new game."
game = Game.new()
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
      @guesses_amount = 10
    else
      @guesses_amount = 7
    end
  end

def save_file()
  filename = @name
  return false unless filename
  # Using self here so it acts like game.save_file where game is passed into the dump. It works!
  dump = YAML.dump(self)
  File.open(File.join(Dir.pwd, "#{filename}.yaml"), 'w') { |file| file.write dump }
end
  def replay()
    puts "Play again? (Y/N)"
    answer = gets.to_s.upcase.chomp
    if ((answer == "Y" || answer == "YES"))
    play_game()
    else      
      puts "Thanks for playing!"
    end
  end
  def save_game()
    # if saved game YES (Copy replays conditional), then export it to a file called "game_output." if you later load in a saved game that was completed ensure no errors happen
    # if saved game no, then don't overrwite any existing game_output file. just do nothing besides 'game not saved. goodbye'
    puts "Save Game? (Y/N) Note: this will overwrite any previously saved game."
    answer = gets.to_s.upcase.chomp
    if ((answer == "Y" || answer == "YES"))
    # INFO FOR SAVING DATA GOES HERE
    self.save_file()
    else      
      puts "Ok, the game data will not be saved."
    end
  end
  def play_rounds(word, display, guesses_amount)
    @guesses = []
    @incorrect_guesses = []
    # unless the number of INCORRECT guesses exceeds the number "guesses_amount", keep looping
    loop do
      show_display(display)
      puts "Incorrect letters:" unless @incorrect_guesses.empty?
      p @incorrect_guesses unless @incorrect_guesses.empty?
      loop do
        puts "guess a letter"
        # grab first letter only
        @guess = gets.chomp.to_s.downcase
        if @guess == 'quit'
          break
        else
          # if quit is not typed then grab the first letter
          @guess = @guess[0]
        end
        if @guess.match(/[A-z]/)
        # puts "valid guess of '#{@guess}'."
        break
        else 
          puts "invalid guess of '#{@guess}'."
        end
      end
      # ^ little loop
      # re-loop if guess is already made
      if @guesses.include?(@guess) && @guess != 'quit'
        puts "YOU HAVE ALREADY GUESSED THE LETTER '#{@guess}'."
      elsif @guess == 'quit'
        break
      elsif word.split('').any? { |item| item == @guess }
        puts "'#{@guess}' exists!"
        # split the word to iterate
        word.split('').each_with_index do |item, index|
          # if it matches to guess, update the display with that letter!
          if item == @guess
            display[index] = @guess
          end
        end
      else
        puts "No '#{@guess}'."
        @incorrect_guesses << @guess
        if (@incorrect_guesses.length) == (guesses_amount - 1)
          puts "WARNING: You have one incorrect guess left!"
        end
      end
      # regardless if right or wrong, add the valid guess to an array of guesses
      @guesses << @guess
      # if quit, word is guessed, or limit exceeded, exit (quit condition is already accounted for)
      if display.join() == word
        puts "YOU WIN! The word was '#{word}'."
        break
      elsif
        @incorrect_guesses.length >= guesses_amount
        puts "YOU LOSE! The word was '#{word}'." 
        break
      else
        #keeps looping
      end

    end
    # ^ biggest loop (each round)
    save_game()
    replay()
  end

  def play_game()
    # store the secret word in an instance variable that captures the output from the select_word() module method
    @secret_word = WORDBANK.sample
    # display variable itself must be updated for every place in the array, so only join things to update the display in the console not on the display variable itself!
    @display = Array.new(@secret_word.length, "_")
    # show_display(@display)
    puts "The word to guess is #{@secret_word.length} letters."
    # puts "THE SECRET WORD IS '#{@secret_word}'."
    generate_guesses(@secret_word)
    puts "You have up to #{@guesses_amount} incorrect guesses."
    play_rounds(@secret_word, @display, @guesses_amount)
  end
end

puts "WELCOME TO HANGMAN!"
# here is where you load in the game
puts "Load a saved game? (Y/N)"
answer = gets.to_s.upcase.chomp
    if ((answer == "Y" || answer == "YES"))
    # if answer is yes, then check if file exists then load it. if file DNE, load new game with message 'no saved game found, starting new game.'
    game = load_game()

    puts "This feature is currently in development (as to how to 'resume play' after importing all of the saved data)."
    else      
    # if not loaded, then do the command below (NOTE: play_game will fall outside of the conditional)
    game = Game.new()
    game.play_game()
    end

