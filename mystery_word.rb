require_relative 'plurality_check' if File.exists?('plurality_check.rb')

def main
  play_again = 'y'
  while play_again == 'y'
    play_game
    play_again = ask_if_playing_again
  end
end

def initialize_game
  game = {}
  game[:difficulty] = select_difficulty(game)
  game[:mystery_word] = get_mystery_word(game).downcase
  game[:mistakes_allowed] = 8
  game[:letters_guessed] = []
  game[:current_guess] = ''
  game[:censored_word] = ''

  game
end

def play_game
  game = initialize_game

  print "You can guess wrong #{game[:mistakes_allowed]} times. " \
        "The word has #{game[:mystery_word].length} letters. " \
        "Enter a letter: "

  until game_is_over?(game)
    game[:current_guess] = gets.chomp.downcase

    unless guess_is_invalid?(game)
      add_guess(game)

      remove_chance(game) if word_does_not_contain_letter?(game)

      display_partial_word(game)

      display_game_status(game) unless game_is_over?(game)
    end
  end

  reveal_word(game) if out_of_guesses?(game)
  high_five if word_is_revealed?(game)
end

def game_is_over?(game)
  word_is_revealed?(game) or out_of_guesses?(game)
end

def word_is_revealed?(game)
  unspaced_censored_word = game[:censored_word].delete ' '
  unspaced_censored_word == game[:mystery_word]
end

def out_of_guesses?(game)
  game[:mistakes_allowed] <= 0
end

def select_difficulty(game)
  print 'Do yo want to play (E)asy, (N)ormal, or (H)ard? '

  game[:difficulty] = ''

  until game[:difficulty] =~ /[enh]/
    game[:difficulty] = get_first_char

    print "Please choose easy, normal, or hard: " \
          unless game[:difficulty] =~ /[enh]/

  end

  game[:difficulty]
end

def get_first_char
  gets.chomp.downcase[0]
end

def get_mystery_word(game)
  get_words(game).sample
end

def get_words(game)
  full_word_list = File.readlines("/usr/share/dict/words")
                   .map { |word| word.chomp }

  # I considered skipping this assignment and putting the function directly
  # in the select below, but it looked a bit uglier.
  accepted_length = get_accepted_length(game)

  full_word_list.select { |word| accepted_length.include? word.length }
end

def get_accepted_length(game)
  case game[:difficulty]
  when 'e'
    4..6

  when 'n'
    6..8

  when 'h'
    8..99
  end
end

def add_guess(game)
  game[:letters_guessed] << game[:current_guess]
end

def guess_is_invalid?(game)
  already_guessed?(game) or is_not_single_letter?(game)
end

def is_not_single_letter?(game)
  if not(game[:current_guess] =~ /[a-z]/ and game[:current_guess].length == 1)
    print 'Enter a single letter: '
    true

  end
end

def already_guessed?(game)
  if game[:letters_guessed].include? game[:current_guess]
    print "You tried that one already, enter another letter: "
    true

  end
end

def word_does_not_contain_letter?(game)
  unless game[:mystery_word].include? game[:current_guess]
    puts "Sorry, no #{game[:current_guess]}. "
    true

  end
end

def remove_chance(game)
  game[:mistakes_allowed] -= 1
end

def display_partial_word(game)
  game[:censored_word] = ''

  game[:mystery_word].chars.each do |char|
    game[:censored_word].concat(" #{char} ")
    game[:censored_word].gsub!(char, "_") unless game[:letters_guessed].include? char

  end

  puts game[:censored_word]
end

def display_game_status(game)
  print "You have #{game[:mistakes_allowed]} "

  if defined? plurality_check(game[:mistakes_allowed], 'chance')
    print "#{plurality_check(game[:mistakes_allowed], 'chance')} left. "

  else
    print 'chance(s) left. '
  end

  print "Previous guesses: #{game[:letters_guessed].sort.join(', ')}. " \
        "Choose another letter: "
end

def reveal_word(game)
  print "Sorry, you're out of guesses. The word was #{game[:mystery_word]}. "
end

def high_five
  print 'Nice job! '
end

def ask_if_playing_again
  play_again = ''

  print "Would you like to play again (Y/N)? "

  until play_again =~ /[yn]/
    play_again = get_first_char

    print "Please choose yes or no: " unless play_again =~ /[yn]/
  end

  play_again
end

main if __FILE__ == $PROGRAM_NAME
