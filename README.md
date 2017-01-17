# Mystery-Word
> A game where you attempt to identify a word by guessing letters in the word.

## Usage

At the game's start, you will be asked to select a difficulty, which will determine the length of the word.

* Easy: 4-6 letters
* Medium: 6-8 letters
* Hard: 8+ letters

The game is played by entering a letter; if the word contains the letter, you will be shown where it appears; otherwise, you will lose a guess. The game ends when the full word is revealed, or when you guess wrong 8 times.

## Requirements

The game reads from "/usr/share/dict/words" to generate its word list.

The program looks for ['plurality_check.rb'](https://github.com/adamcreed/Plurality-Check) in the same directory as 'mystery_word.rb'. However, it only provides enhancements to the user experience and is not required to run.

## Release History

* 1.0.1
    * Moved 'plurality_check' to separate file
* 1.0.0
    * Added more feedback to improve gameplay experience
* 0.1.0
    * First functional release
* 0.0.1
    * Work in progress

## About / Contact

Adam Reed – [GitHub](https://github.com/adamcreed/)
 – <kusa.xisa@gmail.com>
