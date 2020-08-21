require 'pry'

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

def compare_totals(player_total, dealer_total)
  if player_total > dealer_total
    'Player'
  elsif dealer_total > player_total
    'Dealer'
  end
end

def determine_winner(player_total, dealer_total)
  if busted?(dealer_total)
    'Player'
  elsif busted?(player_total)
    'Dealer'
  else
    compare_totals(player_total, dealer_total)
  end
end

def say_winner(player_total, dealer_total)
  case determine_winner(player_total, dealer_total)
  when 'Player' then prompt 'Player wins!'
  when 'Dealer' then prompt 'Dealer wins!'
  else
    prompt "It's a tie!"
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

def starting_deck
  cards = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  suits = %w(h s c d)
  deck = cards.product(suits)
  deck.shuffle!
end

def display_starting_hands(player_hand, dealer_hand)
  prompt "Dealer has: #{display_hand(dealer_hand[1])} and unknown card"
  prompt "You have: #{display_hand(player_hand[0])} and " \
    "#{display_hand(player_hand[1])}"
end

def hit_or_stay
  answer = ''
  loop do
    prompt "(h)it or (s)tay?"
    answer = gets.chomp
    break if VALID_CHOICES.include?(answer)
    prompt "Please select a valid choice"
  end

  answer
end

def play_player_hand(hand, deck)
  total = calculate_total(hand)
  loop do
    prompt "Player total is #{total}"

    answer = hit_or_stay
    break if answer == "stay" || answer == "s"

    prompt "Player dealt #{display_hand(deck[0])}"
    hand << deck.shift
    total = calculate_total(hand)

    if busted?(total)
      prompt "Player busted!"
      break
    end
  end

  total
end

def display_dealer_starting_hand(hand, total)
  prompt "Dealer flips up a #{display_hand(hand[0])} " \
    "to go with the #{display_hand(hand[1])} " \
    "for a total of #{total}"
end

def play_dealer_hand(hand, deck, player_total)
  total = calculate_total(hand)
  display_dealer_starting_hand(hand, total)

  unless busted?(player_total)
    until total >= DEALER_STAY
      prompt "Dealer dealt #{display_hand(deck[0])}"
      hand << deck.shift
      total = calculate_total(hand)

      if busted?(total)
        prompt "Dealer busted!"
        break
      end
    end
  end

  total
end

def overall_winner?(player_score, dealer_score)
  player_score == 5 || dealer_score == 5
end

def announce_overall_winner(winner)
  prompt "#{winner} wins the match!"
end

dealer_score = 0
player_score = 0
loop do
  system('clear')
  prompt welcome_message(player_score, dealer_score)
  deck = starting_deck

  first_player_card = deck.shift
  dealer_down_card = deck.shift
  second_player_card = deck.shift
  dealer_up_card = deck.shift

  player_hand = [first_player_card, second_player_card]
  dealer_hand = [dealer_down_card, dealer_up_card]

  display_starting_hands(player_hand, dealer_hand)

  player_total = play_player_hand(player_hand, deck)
  dealer_total = play_dealer_hand(dealer_hand, deck, player_total)

  say_score(player_total, dealer_total)
  say_winner(player_total, dealer_total)
  winner = determine_winner(player_total, dealer_total)
  player_score += 1 if winner == 'Player'
  dealer_score += 1 if winner == 'Dealer'

  if overall_winner?(player_score, dealer_score)
    overall_winner = player_score == 5 ? 'Player' : 'Computer'
    announce_overall_winner(overall_winner)
    break
  end

  prompt "Press enter to deal the next hand"
  answer = gets.chomp
  next unless answer == ''
end
