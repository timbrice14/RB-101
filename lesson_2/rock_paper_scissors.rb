VALID_CHOICES = %w(rock paper scissors lizard spock)

def prompt(message)
  Kernel.puts("=> #{message}")
end

def translate_choice(choice)
  case choice
  when 'r'
    'rock'
  when 'p'
    'paper'
  when 'sc'
    'scissors'
  when 'l'
    'lizard'
  when 'sp'
    'spock'
  end
end

def win?(first, second)
  game_outcomes = { rock: ['lizard', 'scissors'],
                    paper: ['rock', 'spock'],
                    scissors: ['lizard', 'paper'],
                    spock: ['scissors', 'rock'],
                    lizard: ['spock', 'paper'] }
  game_outcomes[first.to_sym].include?(second)
end

def get_result(player, computer)
  if win?(player, computer)
    'player'
  elsif win?(computer, player)
    'computer'
  else
    'tie'
  end
end

def display_result(result)
  if result == "player"
    prompt("You won!")
  elsif result == "computer"
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

def grand_winner?(player_score, computer_score)
  player_score >= 5 || computer_score >= 5
end

loop do
  system('clear')

  player_score = 0
  computer_score = 0

  prompt("The first player to 5 will win!")

  loop do
    choice = ''

    prompt("The current score is Player: #{player_score} Computer:
      #{computer_score}")

    loop do
      prompt("Choose one: [r]ock, [p]aper, [sc]issors, [l]izard, [sp]ock")
      choice = translate_choice(Kernel.gets().chomp())

      if VALID_CHOICES.include?(choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    computer_choice = VALID_CHOICES.sample()

    Kernel.puts("You chose #{choice}; Computer chose #{computer_choice}")

    result = get_result(choice, computer_choice)
    display_result(result)

    player_score += 1 if result == 'player'
    computer_score += 1 if result == 'computer'

    grand_winner = grand_winner?(player_score, computer_score)

    if grand_winner
      prompt("Player is grand winner") if player_score == 5
      prompt("Computer is grand winner") if computer_score == 5
      break
    end
  end

  prompt("Do you want to play again? (Y or N)")
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?('y')
end

prompt("Thank you for playing. Good bye!")
