def select_difficulty(game)
  print 'Do yo want to play (E)asy, (N)ormal, or (H)ard? '

  game[:difficulty] = ''

  until game[:difficulty] =~ /[enh]/
    game[:difficulty] = get_first_char

    puts "Please choose easy, normal, or hard" \
          unless game[:difficulty] =~ /[enh]/

  end

  game[:difficulty]
end

def get_first_char
  gets.chomp[0].downcase
end

def get_mystery_word(game)
  get_words(game).sample
end

def get_words(game)
  full_word_list = File.readlines("/usr/share/dict/words")
                   .map { |word| word.chomp }

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

def add_guess(game)
  game[:letters_guessed] << game[:current_guess]
end

def guess_is_invalid?(game)
  already_guessed?(game) or is_not_single_letter?(game[:current_guess])
end

def is_not_single_letter?(current_guess)
  if is_numeric?(current_guess) or not(current_guess.length == 1)
    print 'Enter a single letter: '
    true
  end
end

def is_numeric?(input)
  input.to_i.to_s == input || input.to_f.to_s == input
end

def already_guessed?(game)
  if game[:letters_guessed].include? game[:current_guess]
    print "You tried that one already, enter another letter: "
    true
  end
end

def remove_guess(game)
  game[:mistakes_allowed] -= 1
end

def word_does_not_contain_letter?(game)
  unless game[:mystery_word].include? game[:letters_guessed].last
    puts "Sorry, no #{game[:letters_guessed].last} "
    true
  else
    false
  end
end

def display_partial_word(game)
  game[:censored_word] = ''

  game[:mystery_word].chars.each do |char|

    game[:censored_word].concat(" #{char} ")
    game[:censored_word].gsub!(char, "_") unless game[:letters_guessed].include? char

  end

  puts game[:censored_word]
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

def display_game_status(game)
  print "You have #{game[:mistakes_allowed]} chances left. " \
        "Previous guesses: #{game[:letters_guessed].join(',')}. " \
        "Choose another letter: "
end

def play_game
  game = {}
  game[:difficulty] = select_difficulty(game)
  game[:mystery_word] = get_mystery_word(game)
  game[:mistakes_allowed] = 8
  game[:letters_guessed] = []
  game[:current_guess] = ''
  game[:censored_word] = ''

  print "You can guess wrong #{game[:mistakes_allowed]} times. " \
        "The word has #{game[:mystery_word].length} letters. " \
        "Enter a letter: "

  until game_is_over?(game)
    game[:current_guess] = gets.chomp

    unless guess_is_invalid?(game)
      add_guess(game)

      remove_guess(game) if word_does_not_contain_letter?(game)

      display_partial_word(game)

      display_game_status(game) unless game_is_over?(game)
    end
  end

  ask_if_playing_again
end

def main
  play_again = 'y'
  while play_again == 'y'
    play_again = play_game
  end
end

main
