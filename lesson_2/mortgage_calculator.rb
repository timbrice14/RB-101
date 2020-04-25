require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

def display_welcome
  puts messages('welcome')
  puts messages('enter_name')
end

def retrieve_user_name
  user_name = ''
  loop do
    user_name = gets.chomp

    if user_name.strip.empty?
      puts messages('invalid_name')
    else
      break
    end
  end

  user_name
end

def display_greeting(user_name)
  puts format(messages('user_input'), name: user_name)
end

def retrieve_total_amount
  total_amount = ''
  loop do
    puts messages('total_amount')
    total_amount = gets.chomp
    if valid_loan_amount?(total_amount)
      break
    else
      puts messages('invalid_total_amount')
    end
  end

  total_amount
end

def retrieve_apr
  annual_percentage_rate = ''
  loop do
    puts messages('annual_percentage_rate')
    annual_percentage_rate = gets.chomp
    if valid_apr?(annual_percentage_rate)
      break
    else
      puts messages('invalid_annual_percentage_rate')
    end
  end

  annual_percentage_rate
end

def retrieve_loan_duration
  loan_duration = ''
  loop do
    puts messages('total_duration')
    loan_duration = gets.chomp
    if valid_loan_duration?(loan_duration)
      break
    else
      puts messages('invalid_total_duration')
    end
  end

  loan_duration
end

def monthly_interest_rate(annual_percentage_rate)
  (annual_percentage_rate.to_f / 100) / 12
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

def valid_loan_amount?(number)
  /\d+/.match(number) && number.to_i > 0
end

def valid_apr?(number)
  (/\.\d+/.match(number) || /\d+/.match(number)) && number.to_f > 0
end

def valid_loan_duration?(number)
  /^[0-9]*$/.match(number) && number.to_i > 0
end

def messages(message)
  ">> #{MESSAGES[message]}"
end

display_welcome
user_name = retrieve_user_name
display_greeting(user_name)
total_amount = retrieve_total_amount
annual_percentage_rate = retrieve_apr
loan_duration = retrieve_loan_duration

monthly_payment = calculate_monthly_payment(total_amount,
                                            annual_percentage_rate,
                                            loan_duration)
puts format(messages('monthly_payment'), payment: monthly_payment)
