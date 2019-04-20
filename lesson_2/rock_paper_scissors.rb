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

def display_result(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

loop do
  choice = ''
  valid_short_choices = %w(r p sc l sp)
  loop do
    prompt("Choose one: #{valid_short_choices.join(', ')}")
    choice = translate_choice(Kernel.gets().chomp())

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  computer_choice = VALID_CHOICES.sample()

  Kernel.puts("You chose #{choice}; Computer chose #{computer_choice}")

  display_result(choice, computer_choice)

  prompt("Do you want to play again?")
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?('y')
end

prompt("Thank you for playing. Good bye!")
