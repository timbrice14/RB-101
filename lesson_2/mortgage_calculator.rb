require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

def monthly_interest_rate(annual_percentage_rate)
  annual_percentage_rate.to_f / 12
end

def loan_duration_in_months(loan_duration)
  loan_duration.to_i * 12
end

def calculate_monthly_payment(total_amount, annual_percentage_rate,
                              loan_duration)
  j = monthly_interest_rate(annual_percentage_rate)
  n = loan_duration_in_months(loan_duration)

  format('%02.2f', total_amount.to_i * (j / (1 - (1 + j)**-n)))
end

def valid_number?(number)
  /\d+/.match(number) && number.to_i > 0
end

def valid_float?(number)
  /\.\d+/.match(number) && number.to_f > 0
end

def messages(message)
  ">> #{MESSAGES[message]}"
end

puts messages('welcome')
puts messages('enter_name')

name = ''
loop do
  name = gets.chomp

  if name.empty?
    puts messages('invalid_name')
  else
    break
  end
end

puts format(messages('user_input'), name: 'Tim')

total_amount = ''
loop do
  puts messages('total_amount')
  total_amount = gets.chomp
  if valid_number?(total_amount)
    break
  else
    puts messages('invalid_total_amount')
  end
end

annual_percentage_rate = ''
loop do
  puts messages('annual_percentage_rate')
  annual_percentage_rate = gets.chomp
  if valid_float?(annual_percentage_rate)
    break
  else
    puts messages('invalid_annual_percentage_rate')
  end
end

loan_duration = ''
loop do
  puts messages('total_duration')
  loan_duration = gets.chomp
  if valid_number?(loan_duration)
    break
  else
    puts messages('invalid_total_duration')
  end
end

monthly_payment = calculate_monthly_payment(total_amount,
                                            annual_percentage_rate,
                                            loan_duration)
puts format(messages('monthly_payment'), payment: monthly_payment)
