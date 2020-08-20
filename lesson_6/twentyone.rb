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
    sum += if busted?(sum + ACE_HIGH_VALUE)
             ACE_LOW_VALUE
           else
             ACE_HIGH_VALUE
           end
  end
  sum
end

def get_points(card)
  case card
  when 'A' then 'Ace'
  when 'J', 'Q', 'K' then 10
  else
    card.to_i
  end
end

def calculate_total(hand)
  hand = hand.map { |h| get_points(h[0]) }

  if hand.include?("Ace")
    sum = hand.reject { |card| card == "Ace" }.sum
    ace_count = hand.count("Ace")
    calculate_sum_with_ace(sum, ace_count)
  else
    hand.sum
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

def translate_card(card)
  case card
  when 'A' then 'Ace'
  when 'J' then 'Jack'
  when 'Q' then 'Queen'
  when 'K' then 'King'
  else
    card
  end
end

def translate_suit(suit)
  case suit
  when 'h' then 'Hearts'
  when 'c' then 'Clubs'
  when 'd' then 'Diamonds'
  when 's' then 'Spades'
  end
end

def display_hand(hand)
  "#{translate_card(hand[0])} of #{translate_suit(hand[1])}"
end

dealer_score = 0
player_score = 0
loop do
  system('clear')
  prompt welcome_message(player_score, dealer_score)
  cards = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  suits = %w(h s c d)
  deck = cards.product(suits)
  deck.shuffle!

  first_player_card = deck.shift
  dealer_down_card = deck.shift
  second_player_card = deck.shift
  dealer_up_card = deck.shift

  player_hand = [first_player_card, second_player_card]
  dealer_hand = [dealer_down_card, dealer_up_card]

  prompt "Dealer has: #{display_hand(dealer_up_card)} and unknown card"
  prompt "You have: #{display_hand(first_player_card)} and " \
    "#{display_hand(second_player_card)}"

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

    prompt "Player dealt #{display_hand(deck[0])}"
    player_hand << deck.shift
    player_total = calculate_total(player_hand)

    if busted?(player_total)
      prompt "Player busted!"
      break
    end
  end

  dealer_total = calculate_total(dealer_hand)
  prompt "Dealer flips up a #{display_hand(dealer_down_card)} of " \
    "to go with the #{display_hand(dealer_up_card)} " \
    "for a total of #{dealer_total}"

  if busted?(player_total)
    say_score(player_total, dealer_total)
    say_winner(player_total, dealer_total)
    dealer_score += 1
  else
    until dealer_total >= DEALER_STAY
      prompt "Dealer dealt #{display_hand(deck[0])}"
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

  prompt "Press enter to deal the next hand"
  answer = gets.chomp
  next unless answer == ''
end
