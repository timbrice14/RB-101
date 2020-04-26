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

  first_player_card = deck[0]
  computer_down_card = deck[1]
  second_player_card = deck[2]
  computer_up_card = deck[3]

  player_hand = [first_player_card, second_player_card]
  computer_hand = [computer_down_card, computer_up_card]

  puts "Dealer has: #{computer_hand[1]} and unknown card"
  puts "You have: #{player_hand[0]} and #{player_hand[1]}"

  card_count = 4
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

    puts "Player dealt #{deck[card_count]}"
    player_hand << deck[card_count]
    player_total = calculate_total(player_hand)
    card_count += 1

    if busted?(player_total)
      puts "Player busted!"
      break
    end
  end

  puts "Computer flips up: #{computer_down_card}"
  computer_total = calculate_total(computer_hand)

  if busted?(player_total)
    say_score(player_total, computer_total)
    say_winner(player_total, computer_total)
  else
    until computer_total >= 17
      puts "Computer dealt #{deck[card_count]}"
      computer_hand << deck[card_count]
      computer_total = calculate_total(computer_hand)

      if busted?(computer_total)
        say_score(player_total, computer_total)
        say_winner(player_total, computer_total)
        break
      end
      card_count += 1
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
