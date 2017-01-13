def select_difficulty
  print 'Do yo want to play (E)asy, (N)ormal, or (H)ard? '

  game_difficulty = ''

  until game_difficulty =~ /[enh]/
    game_difficulty = get_first_char

    puts "Please choose easy, normal, or hard" unless game_difficulty =~ /[enh]/
  end

  game_difficulty
end

def get_first_char
  gets.chomp[0].downcase
end

def get_mystery_word(game_difficulty)
  get_words(game_difficulty).sample
end

def get_words(game_difficulty)
  full_word_list = File.readlines("/usr/share/dict/words")
                   .map { |word| word.chomp }

  accepted_length = get_accepted_length(game_difficulty)

  full_word_list.select { |word| accepted_length.include? word.length }
end

def get_accepted_length(game_difficulty)
  case game_difficulty
  when 'e'
    4..6

  when 'n'
    6..8

  when 'h'
    8..99
  end
end

def play_game
  game_difficulty = select_difficulty
  mystery_word = get_mystery_word(game_difficulty)
  guesses_allowed = 8
  letters_guessed = []

  print " You can guess wrong #{guesses_allowed} times. "\
          "The word has #{mystery_word.length} letters. Enter a letter: "

#   until game_is_over?
#     add_guess(letters_guessed)
#
#     remove_guess if word_does_not_contain_letter?(letters_guessed.last)
#
#     display_partial_word(letters_guessed)
#   end
#
#   play_again?
# end
#
# def main
#   play_again = true
#   while play_again
#     play_again = play_game
#   end
end

play_game
