WINNING_TOTAL = 21
DEALER_STAY = 17
VALID_CHOICES = %w(hit h stay s)
ACE_HIGH_VALUE = 11
ACE_LOW_VALUE = 1

def prompt(msg)
  puts "=> #{msg}"
end

def welcome_message(player_score, computer_score)
  prompt "Welcome to #{WINNING_TOTAL}! The first player to 5 wins! The " \
    "current score is: Player: #{player_score} Computer: #{computer_score}"
end

def busted?(sum)
  sum > WINNING_TOTAL
end

def calculate_sum_with_ace(sum, ace_count)
  if ace_count > 1
    ace_value_total = ACE_HIGH_VALUE + (ace_count - 1)
    sum += if busted?(sum + ace_value_total)
             ace_count
           else
             ace_value_total
           end
  else
    busted?(sum + ACE_HIGH_VALUE) ? sum += ACE_LOW_VALUE : sum += ACE_HIGH_VALUE
  end
  sum
end

def calculate_total(hand)
  if hand.include?("Ace")
    sum = hand.reject { |card| card == "Ace" }.map(&:to_i).sum
    ace_count = hand.count("Ace")
    calculate_sum_with_ace(sum, ace_count)
  else
    hand.map(&:to_i).sum
  end
end

def say_score(player_total, computer_total)
  prompt "Player has #{player_total}. Computer has #{computer_total}."
end

def determine_winner(player_total, computer_total)
  if busted?(computer_total) || player_total > computer_total
    'Player'
  elsif busted?(player_total) || computer_total > player_total
    'Computer'
  else
    'Tie'
  end
end

def say_winner(player_total, computer_total)
  case determine_winner(player_total, computer_total)
  when 'Computer'
    prompt 'Computer wins!'
  when 'Player'
    prompt 'Player wins!'
  else
    prompt "It's a tie!"
  end
end

computer_score = 0
player_score = 0
loop do
  system('clear')
  prompt welcome_message(player_score, computer_score)
  deck = %w(Ace Ace Ace Ace 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 7 7 7 7 8
            8 8 8 9 9 9 9 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10)
  deck.shuffle!

  first_player_card = deck.shift
  computer_down_card = deck.shift
  second_player_card = deck.shift
  computer_up_card = deck.shift

  player_hand = [first_player_card, second_player_card]
  computer_hand = [computer_down_card, computer_up_card]

  prompt "Dealer has: #{computer_hand[1]} and unknown card"
  prompt "You have: #{player_hand[0]} and #{player_hand[1]}"

  player_total = 0
  loop do
    player_total = calculate_total(player_hand)
    prompt "Player total is #{player_total}"

    answer = ''
    loop do
      prompt "(h)it or (s)tay?"
      answer = gets.chomp
      break if VALID_CHOICES.include?(answer)
      prompt "Please select a valid choice"
    end
    break if answer == "stay" || answer == "s"

    prompt "Player dealt #{deck[0]}"
    player_hand << deck.shift
    player_total = calculate_total(player_hand)

    if busted?(player_total)
      prompt "Player busted!"
      break
    end
  end

  computer_total = calculate_total(computer_hand)
  prompt "Computer flips up a #{computer_down_card} to go with the " \
    "#{computer_up_card} for a total of #{computer_total}"

  if busted?(player_total)
    say_score(player_total, computer_total)
    say_winner(player_total, computer_total)
    computer_score += 1
  else
    until computer_total >= DEALER_STAY
      prompt "Computer dealt #{deck[0]}"
      computer_hand << deck.shift
      computer_total = calculate_total(computer_hand)

      if busted?(computer_total)
        say_score(player_total, computer_total)
        say_winner(player_total, computer_total)
        player_score += 1
        break
      end
    end
  end

  unless busted?(computer_total) || busted?(player_total)
    say_score(player_total, computer_total)
    say_winner(player_total, computer_total)
    winner = determine_winner(player_total, computer_score)
    player_score += 1 if winner == 'Player'
    computer_score += 1 if winner == 'Computer'
  end

  if computer_score == 5
    prompt "Computer wins the match!"
    break
  elsif player_score == 5
    prompt "Player wins the match!"
    break
  end

  prompt "Press any key to deal the next hand"
  answer = gets.chomp
  next unless answer == ''
end
