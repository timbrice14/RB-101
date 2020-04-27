WINNING_TOTAL = 21
DEALER_STAY = 17
VALID_CHOICES = %w(hit h stay s)
ACE_HIGH_VALUE = 11
ACE_LOW_VALUE = 1

def prompt(msg)
  puts "=> #{msg}"
end

def welcome_message(player_score, dealer_score)
  prompt "Welcome to #{WINNING_TOTAL}! The first player to 5 wins! The " \
    "current score is: Player: #{player_score} Dealer: #{dealer_score}"
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

def say_score(player_total, dealer_total)
  prompt "Player has #{player_total}. Dealer has #{dealer_total}."
end

def determine_winner(player_total, dealer_total)
  if player_total > dealer_total
    'Player'
  elsif dealer_total > player_total
    'Dealer'
  else
    'Tie'
  end
end

def say_winner(player_total, dealer_total)
  if busted?(dealer_total)
    prompt 'Player wins!'
  elsif busted?(player_total)
    prompt 'Dealer wins'
  else
    case determine_winner(player_total, dealer_total)
    when 'Dealer'
      prompt 'Dealer wins!'
    when 'Player'
      prompt 'Player wins!'
    else
      prompt "It's a tie!"
    end
  end
end

dealer_score = 0
player_score = 0
loop do
  system('clear')
  prompt welcome_message(player_score, dealer_score)
  deck = %w(Ace Ace Ace Ace 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 7 7 7 7 8
            8 8 8 9 9 9 9 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10)
  deck.shuffle!

  first_player_card = deck.shift
  dealer_down_card = deck.shift
  second_player_card = deck.shift
  dealer_up_card = deck.shift

  player_hand = [first_player_card, second_player_card]
  dealer_hand = [dealer_down_card, dealer_up_card]

  prompt "Dealer has: #{dealer_hand[1]} and unknown card"
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

  dealer_total = calculate_total(dealer_hand)
  prompt "Dealer flips up a #{dealer_down_card} to go with the " \
    "#{dealer_up_card} for a total of #{dealer_total}"

  if busted?(player_total)
    say_score(player_total, dealer_total)
    say_winner(player_total, dealer_total)
    dealer_score += 1
  else
    until dealer_total >= DEALER_STAY
      prompt "Dealer dealt #{deck[0]}"
      dealer_hand << deck.shift
      dealer_total = calculate_total(dealer_hand)

      if busted?(dealer_total)
        say_score(player_total, dealer_total)
        say_winner(player_total, dealer_total)
        player_score += 1
        break
      end
    end
  end

  unless busted?(dealer_total) || busted?(player_total)
    say_score(player_total, dealer_total)
    say_winner(player_total, dealer_total)
    winner = determine_winner(player_total, dealer_total)
    player_score += 1 if winner == 'Player'
    dealer_score += 1 if winner == 'Dealer'
  end

  if dealer_score == 5
    prompt "Dealer wins the match!"
    break
  elsif player_score == 5
    prompt "Player wins the match!"
    break
  end

  prompt "Press any key to deal the next hand"
  answer = gets.chomp
  next unless answer == ''
end
