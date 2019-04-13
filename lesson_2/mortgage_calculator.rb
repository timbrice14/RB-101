def monthly_interest(annual_percentage_rate)
  annual_percentage_rate.to_f / 12
end

def loan_duration_in_months(loan_duration)
  loan_duration.to_f / 12
end

def calculate_monthly_payment(total_amount, annual_percentage_rate, loan_duration)
  j = monthly_interest(annual_percentage_rate)
  n = loan_duration_in_months(loan_duration)

  puts "Value of j is #{j}"
  puts "Value of na is #{n}"

  total_amount.to_i * (j / (1 - (1 + j) ** (-n)))
end

def valid_number?(number)
  number.to_i.to_s == number
end

def prompt(message)
  puts ">> #{message}"
end

prompt("Welcome to the mortgage calculator.")
prompt("We will calculate what your monthly payment will be.")
prompt("To start, enter your name:")

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt("Please enter your name.")
  else
    break
  end
end

prompt("Hi #{name}. Let's get some info to calculate your payment")

total_amount = ''
loop do
  prompt("Please enter the total loan amount:")
  total_amount = gets.chomp
  if valid_number?(total_amount)
    break
  else
    prompt("Please enter a valid number for the total loan amount")
  end
end

annual_percentage_rate = ''
loop do
  prompt("Please enter the annual percentage rate")
  annual_percentage_rate = gets.chomp
  if valid_number?(annual_percentage_rate)
    break
  else
    prompt("Please enter a valid number for the annual percentage rate")
  end
end

loan_duration = ''
loop do
  prompt("Please enter the duration of that loan")
  loan_duration = gets.chomp
  if valid_number?(loan_duration)
    break
  else
    prompt("Please enter a valid loan duration")
  end
end

puts "Your monthly payment will be #{calculate_monthly_payment(total_amount, annual_percentage_rate, loan_duration)}"
