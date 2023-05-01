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
      @guesses_amount = 10
    else
      @guesses_amount = 7
    end
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
          puts "GOODBYE"
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
        puts "GOODBYE AGAIN"
        break
      elsif word.split('').any? { |item| item == @guess }
        puts "#{@guess} exists!"
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
    puts "Save Game? (Y/N)"
    replay()

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
    puts "You have up to #{@guesses_amount} incorrect guesses."
    play_rounds(@secret_word, @display, @guesses_amount)
  end
end

game = Game.new()
game.play_game
