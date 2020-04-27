require 'pry'
require 'pry-byebug'

VALID_CHOICES = %w(hit h stay s)
ACE_HIGH_VALUE = 11
ACE_LOW_VALUE = 1

def busted?(sum)
  sum > 21
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
  puts "Player has #{player_total}. Computer has #{computer_total}."
end

def determine_winner(player_total, computer_total)
  if busted?(computer_total) || player_total > computer_total
    'Player'
  elsif busted?(player_total) || computer_total > player_total
    'Player'
  else
    'Tie'
  end
end

def say_winner(player_total, computer_total)
  case determine_winner(player_total, computer_total)
  when 'Computer'
    puts 'Computer wins!'
  when 'Player'
    puts 'Player wins!'
  else
    puts "It's a tie!"
  end
end

loop do
  system('clear')
  deck = %w(Ace Ace Ace Ace 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 7 7 7 7 8
            8 8 8 9 9 9 9 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10)
  deck.shuffle!

  first_player_card = deck.shift
  computer_down_card = deck.shift
  second_player_card = deck.shift
  computer_up_card = deck.shift

  player_hand = [first_player_card, second_player_card]
  computer_hand = [computer_down_card, computer_up_card]

  puts "Dealer has: #{computer_hand[1]} and unknown card"
  puts "You have: #{player_hand[0]} and #{player_hand[1]}"

  player_total = 0
  loop do
    player_total = calculate_total(player_hand)
    puts "Player total is #{player_total}"

    answer = ''
    loop do
      puts "(h)it or (s)tay?"
      answer = gets.chomp
      break if VALID_CHOICES.include?(answer)
      puts "Please select a valid choice"
    end
    break if answer == "stay" || answer == "s"

    puts "Player dealt #{deck[0]}"
    player_hand << deck.shift
    player_total = calculate_total(player_hand)

    if busted?(player_total)
      puts "Player busted!"
      break
    end
  end

  computer_total = calculate_total(computer_hand)
  puts "Computer flips up a #{computer_down_card} to go with the #{computer_up_card} for a total of #{computer_total}"

  if busted?(player_total)
    say_score(player_total, computer_total)
    say_winner(player_total, computer_total)
  else
    until computer_total >= 17
      binding.pry
      puts "Computer dealt #{deck[0]}"
      computer_hand << deck.shift
      computer_total = calculate_total(computer_hand)

      if busted?(computer_total)
        say_score(player_total, computer_total)
        say_winner(player_total, computer_total)
        break
      end
    end
  end

  unless busted?(computer_total) || busted?(player_total)
    say_score(player_total, computer_total)
    say_winner(player_total, computer_total)
  end

  puts "Play again?"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end
